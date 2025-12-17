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
// routes/transaction.js
const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const pool = require('../db'); // giả sử export mysql2 promise pool

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

/**
 * POST /api/transaction
 * Thêm giao dịch, update số dư, tạo thông báo chung,
 * kiểm tra ngân sách (nếu loai='Chi') và tạo thông báo cảnh báo khi >=80%.
 *
 * Response JSON:
 * { success: true, message: '', warning: boolean, percent: number, currentBalance: number }
 */

router.post('/', upload.single('billImage'), async (req, res) => {
  const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  // Basic validation
  if (!userId || !accountId || !danhMucId || !type || !amount || !date) {
    console.warn('[transaction] Thiếu thông tin:', { userId, accountId, danhMucId, type, amount, date });
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });
  }

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount)) {
    console.warn('[transaction] Số tiền không hợp lệ:', amount);
    return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    console.log('[transaction] Bắt đầu thêm giao dịch:', { userId, accountId, danhMucId, type, parsedAmount, date });

    // 1) Thêm giao dịch
    const insertSql = `
      INSERT INTO giao_dich
        (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    await conn.execute(insertSql, [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]);
    console.log('[transaction] Đã INSERT giao_dich');

    // 2) Cập nhật số dư tài khoản
    const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
    if (!rows || rows.length === 0) {
      throw new Error('Tài khoản không tồn tại');
    }
    let currentBalance = parseFloat(rows[0].so_du) || 0;
    currentBalance = type === 'Chi' ? currentBalance - parsedAmount : currentBalance + parsedAmount;
    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);
    console.log('[transaction] Số dư mới cập nhật:', currentBalance);

    // 3) Thông báo thêm giao dịch (loại Khác)
    const notiContent = `Bạn vừa thêm giao dịch ${type} trị giá ${parsedAmount}đ`;
    await conn.execute(
      'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
      [userId, notiContent, 'Gợi ý'] // đổi 'Khác' -> 'Gợi ý' phù hợp với ràng buộc loai trong bảng
    );
    console.log('[transaction] Đã insert thong_bao (thêm giao dịch)');

    // 4) Kiểm tra ngân sách (chỉ cho 'Chi')
    let warning = false;
    let percent = 0;

    if (type === 'Chi') {
      // CHÚ Ý: date có thể ở dạng ISO (có time) -> convert về YYYY-MM-DD để so sánh DATE trong MySQL
      const sqlDate = (typeof date === 'string') ? date.split('T')[0] : new Date(date).toISOString().split('T')[0];
      console.log('[transaction] Kiểm tra ngân sách cho ngày:', sqlDate, 'danhMucId:', danhMucId);

      // Lấy ngân sách có bao phủ ngày giao dịch (theo ngay_bat_dau <= date <= ngay_ket_thuc)
      const [budgetRows] = await conn.execute(
        `SELECT id, so_tien_gioi_han, chu_ky, ngay_bat_dau, ngay_ket_thuc
         FROM ngan_sach
         WHERE nguoi_dung_id=? AND danh_muc_id=? 
           AND ngay_bat_dau <= ? AND (ngay_ket_thuc IS NULL OR ngay_ket_thuc >= ?)`,
        [userId, danhMucId, sqlDate, sqlDate]
      );

      console.log('[transaction] budgetRows length =', budgetRows.length, 'rows =', budgetRows);

      if (!budgetRows || budgetRows.length === 0) {
        console.log('[transaction] Không tìm thấy ngân sách khớp danh mục/chu kỳ cho giao dịch này -> không cảnh báo');
      } else {
        // Nếu có nhiều bản ghi (ít khi xảy ra), ta lấy bản ghi đầu tiên (hoặc logic ưu tiên theo nhu cầu)
        const budgetRow = budgetRows[0];
        const budgetLimit = parseFloat(budgetRow.so_tien_gioi_han) || 0;
        const periodStart = budgetRow.ngay_bat_dau;   // DATE
        const periodEnd = budgetRow.ngay_ket_thuc || sqlDate; // nếu NULL dùng sqlDate

        console.log('[transaction] Ngân sách tìm được:', { budgetLimit, periodStart, periodEnd });

        // Tính tổng đã chi trong kỳ (tính cả giao dịch vừa insert vì đã insert ở bước 1)
        const [sumRows] = await conn.execute(
          `SELECT IFNULL(SUM(so_tien), 0) AS total FROM giao_dich
           WHERE nguoi_dung_id=? AND danh_muc_id=? AND loai_gd='Chi'
             AND DATE(ngay_giao_dich) BETWEEN ? AND ?`,
          [userId, danhMucId, periodStart, periodEnd]
        );

        const total = parseFloat(sumRows[0].total) || 0;
        percent = budgetLimit > 0 ? Math.round((total / budgetLimit) * 100) : 0;

        console.log('[transaction] Tổng đã chi trong kỳ:', total, 'Giới hạn:', budgetLimit, 'Percent:', percent);

        // Nếu đạt >= 80% thì tạo thông báo cảnh báo
        if (budgetLimit > 0 && percent >= 80) {
          warning = true;
          const warningText = `⚠ Bạn đã dùng ${percent}% ngân sách cho danh mục này trong kỳ (từ ${periodStart} đến ${periodEnd})`;
          await conn.execute(
            `INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao)
             VALUES (?, ?, 'Cảnh báo', 0, NOW())`,
            [userId, warningText]
          );
          console.log('[transaction] WARNING TRIGGERED -> thong_bao inserted:', warningText);
        } else {
          console.log('[transaction] Warning not triggered (percent < 80 hoặc budgetLimit=0)');
        }
      }
    } // end if type === 'Chi'

    await conn.commit();

    // Trả về cho frontend bao gồm warning+percent để UI hiển thị banner/dialog
    return res.json({
      success: true,
      message: 'Thêm giao dịch thành công',
      warning,
      percent,
      currentBalance
    });

  } catch (err) {
    await conn.rollback();
    console.error('Lỗi lưu giao dịch:', err);
    return res.status(500).json({ success: false, message: 'Lỗi server', error: err.message });
  } finally {
    conn.release();
  }
});

module.exports = router;
