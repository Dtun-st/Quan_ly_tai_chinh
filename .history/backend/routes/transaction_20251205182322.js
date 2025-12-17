// // const express = require('express');
// // const router = express.Router();
// // const multer = require('multer');
// // const path = require('path');
// // const pool = require('../db');

// // // --- Multer storage ---
// // const storage = multer.diskStorage({
// //   destination: (req, file, cb) => cb(null, 'uploads/'),
// //   filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
// // });
// // const upload = multer({ storage });
// // // Thêm giao dịch
// // router.post('/', upload.single('billImage'), async (req, res) => {
// //   const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
// //   const billImage = req.file ? `/uploads/${req.file.filename}` : null;

// //   if (!userId || !accountId || !danhMucId || !type || !amount || !date)
// //     return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

// //   const parsedAmount = parseFloat(amount);
// //   if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

// //   const conn = await pool.getConnection();
// //   try {
// //     await conn.beginTransaction();

// //     // Lưu giao dịch
// //     await conn.execute(
// //       `INSERT INTO giao_dich
// //        (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
// //        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
// //       [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]
// //     );

// //     // Cập nhật số dư tài khoản
// //     const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
// //     if (!rows.length) throw new Error('Tài khoản không tồn tại');
// //     let currentBalance = parseFloat(rows[0].so_du);
// //     currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;
// //     await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

// //     // Thêm thông báo
// //     const content = `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount}đ`;
// //     await conn.execute(
// //       'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
// //       [userId, content, 'Khác']
// //     );

// //     await conn.commit();
// //     res.json({ success: true, message: 'Giao dịch và thông báo lưu thành công' });
// //   } catch (err) {
// //     await conn.rollback();
// //     console.error('Lỗi lưu giao dịch:', err);
// //     res.status(500).json({ success: false, message: 'Lỗi server' });
// //   } finally {
// //     conn.release();
// //   }
// // });

// // module.exports = router;
// const express = require('express');
// const router = express.Router();
// const multer = require('multer');
// const path = require('path');
// const pool = require('../db');

// const storage = multer.diskStorage({
//   destination: (req, file, cb) => cb(null, 'uploads/'),
//   filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
// });
// const upload = multer({ storage });

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

//     // 1. Thêm giao dịch
//     await conn.execute(
//       `INSERT INTO giao_dich 
//         (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
//       [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]
//     );

//     // 2. Cập nhật số dư tài khoản
//     const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
//     let currentBalance = parseFloat(rows[0].so_du);
//     currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;
//     await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

//     // 3. Thông báo thêm giao dịch
//     await conn.execute(
//       'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
//       [userId, `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount}đ`, 'Khác']
//     );

//     // 4. Kiểm tra ngân sách (chỉ áp dụng cho Chi)
//     let warning = false;
//     let percent = 0;

//     if (type === 'Chi') {

//       const sqlDate = date.split('T')[0]; // ⭐ chuyển về yyyy-mm-dd

//       const [budgetRows] = await conn.execute(
//         `SELECT so_tien_gioi_han, ngay_bat_dau, ngay_ket_thuc
//      FROM ngan_sach 
//      WHERE nguoi_dung_id=? AND danh_muc_id=? 
//      AND ngay_bat_dau <= ? AND ngay_ket_thuc >= ?`,
//         [userId, danhMucId, sqlDate, sqlDate]
//       );

//       if (budgetRows.length) {
//         const budget = parseFloat(budgetRows[0].so_tien_gioi_han);

//         const [sumRows] = await conn.execute(
//           `SELECT SUM(so_tien) AS total FROM giao_dich
//        WHERE nguoi_dung_id=? AND danh_muc_id=? AND loai_gd='Chi'
//        AND ngay_giao_dich BETWEEN ? AND ?`,
//           [userId, danhMucId, budgetRows[0].ngay_bat_dau, budgetRows[0].ngay_ket_thuc]
//         );

//         const total = parseFloat(sumRows[0].total) || 0;
//         percent = Math.round((total / budget) * 100);

//         if (percent >= 80) {
//           warning = true;
//           await conn.execute(
//             `INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao)
//          VALUES (?, ?, 'Cảnh báo', 0, NOW())`,
//             [userId, `Bạn đã dùng ${percent}% ngân sách kỳ này cho ${danhMucId}!`]
//           );
//         }
//       }
//     }

//     await conn.commit();

//     res.json({
//       success: true,
//       message: 'Thêm giao dịch thành công',
//       warning,
//       percent,
//       currentBalance
//     });

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
const pool = require('../db'); // mysql2 promise pool

// cấu hình multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

/**
 * POST /api/transaction
 * Thêm giao dịch, cập nhật số dư, tạo thông báo, kiểm tra ngân sách theo tháng
 */
router.post('/', upload.single('billImage'), async (req, res) => {
  const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  // 1) Validate
  if (!userId || !accountId || !type || !amount || !date) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin bắt buộc' });
  }

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount)) {
    return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // 2) Thêm giao dịch
    await conn.execute(
      `INSERT INTO giao_dich 
      (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, danhMucId || null, type, parsedAmount, description || '', date, billImage]
    );

    // 3) Cập nhật số dư
    const [accountRows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
    if (!accountRows || accountRows.length === 0) throw new Error('Tài khoản không tồn tại');

    let currentBalance = parseFloat(accountRows[0].so_du) || 0;
    currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;
    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

    // 4) Thêm thông báo giao dịch
    const notiContent = `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount.toLocaleString()}đ`;
    await conn.execute(
      `INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao)
       VALUES (?, ?, 'Gợi ý', 0, NOW())`,
      [userId, notiContent]
    );

    // 5) Kiểm tra ngân sách nếu là Chi
    let warning = false;
    let percent = 0;
    if (type === 'Chi') {
      // Lấy năm-tháng để tính ngân sách theo tháng
      const [budgetRows] = await conn.execute(
        `SELECT * FROM ngan_sach
         WHERE nguoi_dung_id = ?
           AND chu_ky = 'thang'
           AND (danh_muc_id = ? OR danh_muc_id IS NULL OR danh_muc_id = 0)`,
        [userId, danhMucId || 0]
      );

      if (budgetRows.length > 0) {
        const budget = budgetRows[0];
        // Tổng chi trong tháng hiện tại
        const [sumRows] = await conn.execute(
          `SELECT IFNULL(SUM(so_tien),0) AS total
           FROM giao_dich
           WHERE nguoi_dung_id = ?
             AND loai_gd='Chi'
             AND DATE_FORMAT(ngay_giao_dich, '%Y-%m') = DATE_FORMAT(?, '%Y-%m')`,
          [userId, date]
        );

        const totalSpent = parseFloat(sumRows[0].total) || 0;
        percent = budget.so_tien_gioi_han > 0
          ? Math.round((totalSpent / budget.so_tien_gioi_han) * 100)
          : 0;

        if (percent >= 80) {
          warning = true;
          const warningText = `⚠ Bạn đã dùng ${percent}% ngân sách tháng này!`;
          await conn.execute(
            `INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao)
             VALUES (?, ?, 'Cảnh báo', 0, NOW())`,
            [userId, warningText]
          );
        }
      }
    }

    await conn.commit();
    return res.json({ success: true, message: 'Thêm giao dịch thành công', warning, percent, currentBalance });

  } catch (err) {
    await conn.rollback();
    console.error('Lỗi lưu giao dịch:', err);
    return res.status(500).json({ success: false, message: 'Lỗi server', error: err.message });
  } finally {
    conn.release();
  }
});

module.exports = router;
