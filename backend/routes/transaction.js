// const express = require('express');
// const router = express.Router();
// const multer = require('multer');
// const path = require('path');
// const pool = require('../db');

// // --- Multer storage ---
// const storage = multer.diskStorage({
//   destination: (req, file, cb) => cb(null, 'uploads/'),
//   filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
// });
// const upload = multer({ storage });
// // Thêm giao dịch
// router.post('/', upload.single('billImage'), async (req, res) => {
//   const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
//   const billImage = req.file ? `/uploads/${req.file.filename}` : null;

//   if (!userId || !accountId || !danhMucId || !type || !amount || !date)
//     return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

//   const parsedAmount = parseFloat(amount);
//   if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

//   const conn = await pool.getConnection();
//   try {
//     await conn.beginTransaction();

//     // Lưu giao dịch
//     await conn.execute(
//       `INSERT INTO giao_dich
//        (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
//       [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]
//     );

//     // Cập nhật số dư tài khoản
//     const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
//     if (!rows.length) throw new Error('Tài khoản không tồn tại');
//     let currentBalance = parseFloat(rows[0].so_du);
//     currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;
//     await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

//     // Thêm thông báo
//     const content = `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount}đ`;
//     await conn.execute(
//       'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
//       [userId, content, 'Khác']
//     );

//     await conn.commit();
//     res.json({ success: true, message: 'Giao dịch và thông báo lưu thành công' });
//   } catch (err) {
//     await conn.rollback();
//     console.error('Lỗi lưu giao dịch:', err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   } finally {
//     conn.release();
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const pool = require('../db');

// --- Multer storage ---
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// --- Thêm giao dịch ---
router.post('/', upload.single('billImage'), async (req, res) => {
  const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  if (!userId) return res.status(400).json({ success: false, message: 'Thiếu ID người dùng' });
  if (!accountId) return res.status(400).json({ success: false, message: 'Thiếu ID tài khoản' });
  if (!danhMucId) return res.status(400).json({ success: false, message: 'Thiếu ID danh mục' });
  if (!type) return res.status(400).json({ success: false, message: 'Thiếu loại giao dịch (Thu/Chi)' });
  if (!amount) return res.status(400).json({ success: false, message: 'Thiếu số tiền giao dịch' });
  if (!date) return res.status(400).json({ success: false, message: 'Thiếu ngày giao dịch' });

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount) || parsedAmount <= 0) 
    return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ hoặc phải lớn hơn 0' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Lưu giao dịch
    await conn.execute(
      `INSERT INTO giao_dich
       (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]
    );

    // Cập nhật số dư tài khoản
    const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
    if (!rows.length) throw new Error('Không tìm thấy tài khoản với ID này');

    let currentBalance = parseFloat(rows[0].so_du);
    currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;

    if (currentBalance < 0 && type === 'Chi') {
      await conn.rollback();
      return res.status(400).json({ success: false, message: 'Số dư tài khoản không đủ để thực hiện giao dịch' });
    }

    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

    // Thêm thông báo
    const content = `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount.toLocaleString()}đ`;
    await conn.execute(
      'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
      [userId, content, 'Khác']
    );

    await conn.commit();
    res.json({ success: true, message: 'Giao dịch và thông báo đã được lưu thành công' });
  } catch (err) {
    await conn.rollback();
    console.error('❌ Lỗi khi lưu giao dịch:', err.message);
    res.status(500).json({ success: false, message: 'Đã xảy ra lỗi khi lưu giao dịch, vui lòng thử lại sau' });
  } finally {
    conn.release();
  }
});

module.exports = router;
