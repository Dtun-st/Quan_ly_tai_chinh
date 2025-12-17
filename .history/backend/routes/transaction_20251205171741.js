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

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

router.post('/', upload.single('billImage'), async (req, res) => {
  const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  if (!userId || !accountId || !danhMucId || !type || !amount || !date)
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    await conn.execute(
      `INSERT INTO giao_dich
       (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]
    );

    const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
    let currentBalance = parseFloat(rows[0].so_du);
    currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;
    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

    await conn.execute(
      'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
      [userId, `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount}đ`, 'Khác']
    );

    let warning = false;
    let percent = 0;

    if (type === 'Chi') {
      const [budgetRows] = await conn.execute(
        `SELECT so_tien FROM ngan_sach WHERE nguoi_dung_id=? AND danh_muc_id=? 
         AND MONTH(thang)=MONTH(?) AND YEAR(thang)=YEAR(?)`,
        [userId, danhMucId, date, date]
      );

      if (budgetRows.length) {
        const budget = parseFloat(budgetRows[0].so_tien);

        const [sumRows] = await conn.execute(
          `SELECT SUM(so_tien) AS total FROM giao_dich
           WHERE nguoi_dung_id=? AND danh_muc_id=? AND loai_gd='Chi'
           AND MONTH(ngay_giao_dich)=MONTH(?) AND YEAR(ngay_giao_dich)=YEAR(?)`,
          [userId, danhMucId, date, date]
        );

        const total = parseFloat(sumRows[0].total) || 0;
        percent = Math.round((total / budget) * 100);

        if (percent >= 80) {
          warning = true;
          await conn.execute(
            `INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao)
             VALUES (?, ?, 'Cảnh báo', 0, NOW())`,
            [userId, `Bạn đã đạt ${percent}% ngân sách tháng này!`]
          );
        }
      }
    }

    await conn.commit();
    res.json({ success: true, warning, percent });
  } catch (err) {
    await conn.rollback();
    console.error('Lỗi lưu giao dịch:', err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  } finally {
    conn.release();
  }
});

module.exports = router;
