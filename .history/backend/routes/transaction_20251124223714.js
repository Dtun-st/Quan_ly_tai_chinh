// const express = require('express');
// const router = express.Router();
// const multer = require('multer');
// const path = require('path');
// const pool = require('../db'); // MySQL connection

// // --- Multer storage ---
// const storage = multer.diskStorage({
//   destination: (req, file, cb) => cb(null, 'uploads/'),
//   filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
// });
// const upload = multer({ storage });

// // --- Tạo giao dịch ---
// router.post('/', upload.single('billImage'), async (req, res) => {
//   const { userId, accountId, type, categoryName, amount, description, date } = req.body;
//   const billImage = req.file ? `/uploads/${req.file.filename}` : null;

//   if (!userId || !accountId || !type || !categoryName || !amount || !date)
//     return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

//   try {
//     await pool.execute(
//       `INSERT INTO transactions (user_id, account_id, type, category_name, amount, description, date, bill_image)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
//       [userId, accountId, type, categoryName, amount, description || '', date, billImage]
//     );
//     res.json({ success: true, message: 'Giao dịch lưu thành công' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// // --- Lấy tất cả giao dịch ---
// router.get('/:userId', async (req, res) => {
//   const { userId } = req.params;
//   try {
//     const [rows] = await pool.execute('SELECT * FROM transactions WHERE user_id=? ORDER BY date DESC', [userId]);
//     res.json(rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// // --- Cập nhật ---
// router.put('/:id', upload.single('billImage'), async (req, res) => {
//   const { id } = req.params;
//   const { accountId, type, categoryName, amount, description, date } = req.body;
//   const billImage = req.file ? `/uploads/${req.file.filename}` : null;

//   try {
//     const [result] = await pool.execute(
//       `UPDATE transactions SET account_id=?, type=?, category_name=?, amount=?, description=?, date=?, bill_image=COALESCE(?, bill_image)
//        WHERE id=?`,
//       [accountId, type, categoryName, amount, description || '', date, billImage, id]
//     );
//     if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
//     res.json({ success: true, message: 'Cập nhật thành công' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// // --- Xóa ---
// router.delete('/:id', async (req, res) => {
//   const { id } = req.params;
//   try {
//     const [result] = await pool.execute('DELETE FROM transactions WHERE id=?', [id]);
//     if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
//     res.json({ success: true, message: 'Đã xóa giao dịch' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const pool = require('../db'); // MySQL connection

// --- Multer storage ---
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// --- Tạo giao dịch + cập nhật số dư tài khoản ---
router.post('/', upload.single('billImage'), async (req, res) => {
  const { userId, accountId, type, categoryName, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  if (!userId || !accountId || !type || !categoryName || !amount || !date)
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // 1️⃣ Lưu giao dịch
    await conn.execute(
      `INSERT INTO transactions 
       (user_id, account_id, type, category_name, amount, description, date, bill_image)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, type, categoryName, parsedAmount, description || '', date, billImage]
    );

    // 2️⃣ Cập nhật số dư tài khoản
    const [rows] = await conn.execute('SELECT balance FROM accounts WHERE id=?', [accountId]);
    if (!rows.length) throw new Error('Tài khoản không tồn tại');
    let currentBalance = parseFloat(rows[0].balance);

    if (type === 'Chi') currentBalance -= parsedAmount;
    else if (type === 'Thu') currentBalance += parsedAmount;

    await conn.execute('UPDATE accounts SET balance=? WHERE id=?', [currentBalance, accountId]);

    await conn.commit();
    res.json({ success: true, message: 'Giao dịch lưu thành công' });
  } catch (err) {
    await conn.rollback();
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  } finally {
    conn.release();
  }
});

// --- Lấy tất cả giao dịch ---
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute('SELECT * FROM transactions WHERE user_id=? ORDER BY date DESC', [userId]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// --- Cập nhật giao dịch + số dư ---
router.put('/:id', upload.single('billImage'), async (req, res) => {
  const { id } = req.params;
  const { accountId, type, categoryName, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;
  const parsedAmount = parseFloat(amount);

  if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Lấy transaction cũ
    const [oldRows] = await conn.execute('SELECT account_id, type, amount FROM transactions WHERE id=?', [id]);
    if (!oldRows.length) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    const oldTrans = oldRows[0];

    // Hoàn tác số dư cũ
    const [oldAccRows] = await conn.execute('SELECT balance FROM accounts WHERE id=?', [oldTrans.account_id]);
    let oldBalance = parseFloat(oldAccRows[0].balance);
    if (oldTrans.type === 'Chi') oldBalance += parseFloat(oldTrans.amount);
    else oldBalance -= parseFloat(oldTrans.amount);
    await conn.execute('UPDATE accounts SET balance=? WHERE id=?', [oldBalance, oldTrans.account_id]);

    // Cập nhật transaction mới
    await conn.execute(
      `UPDATE transactions 
       SET account_id=?, type=?, category_name=?, amount=?, description=?, date=?, bill_image=COALESCE(?, bill_image)
       WHERE id=?`,
      [accountId, type, categoryName, parsedAmount, description || '', date, billImage, id]
    );

    // Cập nhật số dư mới
    const [newAccRows] = await conn.execute('SELECT balance FROM accounts WHERE id=?', [accountId]);
    let newBalance = parseFloat(newAccRows[0].balance);
    if (type === 'Chi') newBalance -= parsedAmount;
    else newBalance += parsedAmount;
    await conn.execute('UPDATE accounts SET balance=? WHERE id=?', [newBalance, accountId]);

    await conn.commit();
    res.json({ success: true, message: 'Cập nhật thành công' });
  } catch (err) {
    await conn.rollback();
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  } finally {
    conn.release();
  }
});

// --- Xóa giao dịch ---
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await pool.execute('DELETE FROM transactions WHERE id=?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    res.json({ success: true, message: 'Đã xóa giao dịch' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
