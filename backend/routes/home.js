// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// // Lấy tài khoản
// router.get('/tai_khoan/:userId', async (req, res) => {
//   const userId = req.params.userId;
//   try {
//     const [accounts] = await pool.execute(
//       'SELECT id, ten_tai_khoan AS ten, loai_tai_khoan AS loai, so_du FROM tai_khoan WHERE nguoi_dung_id = ?',
//       [userId]
//     );
//     res.json({ accounts });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ accounts: [] });
//   }
// });

// // Lấy giao dịch
// router.get('/giao_dich/:userId', async (req, res) => {
//   const userId = req.params.userId;
//   try {
//     const [transactions] = await pool.execute(
//       `SELECT gd.id, gd.so_tien, gd.loai_gd AS loai, gd.ngay_giao_dich AS ngay, dm.ten_danh_muc AS han_muc
//        FROM giao_dich gd
//        JOIN danh_muc dm ON gd.danh_muc_id = dm.id
//        WHERE gd.nguoi_dung_id = ?
//        ORDER BY gd.ngay_giao_dich DESC
//        LIMIT 20`,
//       [userId]
//     );
//     res.json({ transactions });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ transactions: [] });
//   }
// });

// // Lấy thông báo
// router.get('/thong_bao/:userId', async (req, res) => {
//   const userId = req.params.userId;
//   try {
//     const [notifications] = await pool.execute(
//       'SELECT id, noi_dung, loai FROM thong_bao WHERE nguoi_dung_id = ? ORDER BY ngay_tao DESC',
//       [userId]
//     );
//     res.json({ notifications });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ notifications: [] });
//   }
// });


// // 🔥 Lấy ngân sách tháng hiện tại
// router.get('/budget/:userId', async (req, res) => {
//   const userId = req.params.userId;

//   try {
//     const [rows] = await pool.execute(
//       `SELECT so_tien_gioi_han 
//        FROM ngan_sach 
//        WHERE nguoi_dung_id = ?
//        AND chu_ky = 'thang'
//        ORDER BY ngay_tao DESC LIMIT 1`,
//       [userId]
//     );

//     if (rows.length === 0) return res.json({ budget: null });
//     res.json({ budget: rows[0].so_tien_gioi_han });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ budget: null });
//   }
// });


// // 🔥 Lưu hoặc cập nhật ngân sách tháng
// router.post('/budget', async (req, res) => {
//   const { userId, so_tien_gioi_han } = req.body;

//   try {
//     await pool.execute(
//       `INSERT INTO ngan_sach(nguoi_dung_id, so_tien_gioi_han, chu_ky, ngay_bat_dau, ngay_tao)
//        VALUES(?, ?, 'thang', CURDATE(), NOW())`,
//       [userId, so_tien_gioi_han]
//     );

//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false });
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const pool = require('../db');

/**
 * =========================
 * TÀI KHOẢN
 * =========================
 */
router.get('/tai_khoan/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [accounts] = await pool.execute(
      `SELECT id, ten_tai_khoan AS ten, loai_tai_khoan AS loai, so_du
       FROM tai_khoan
       WHERE nguoi_dung_id = ?`,
      [userId]
    );

    res.json({
      success: true,
      accounts,
    });
  } catch (err) {
    console.error('Lỗi lấy tài khoản:', err);
    res.status(500).json({
      success: false,
      message: 'Không thể lấy danh sách tài khoản',
      accounts: [],
    });
  }
});

/**
 * =========================
 * GIAO DỊCH GẦN ĐÂY
 * =========================
 */
router.get('/giao_dich/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [transactions] = await pool.execute(
      `SELECT gd.id,
              gd.so_tien,
              gd.loai_gd AS loai,
              gd.ngay_giao_dich AS ngay,
              dm.ten_danh_muc AS han_muc
       FROM giao_dich gd
       JOIN danh_muc dm ON gd.danh_muc_id = dm.id
       WHERE gd.nguoi_dung_id = ?
       ORDER BY gd.ngay_giao_dich DESC
       LIMIT 20`,
      [userId]
    );

    res.json({
      success: true,
      transactions,
    });
  } catch (err) {
    console.error('Lỗi lấy giao dịch:', err);
    res.status(500).json({
      success: false,
      message: 'Không thể lấy danh sách giao dịch',
      transactions: [],
    });
  }
});

/**
 * =========================
 * THÔNG BÁO
 * =========================
 */
router.get('/thong_bao/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [notifications] = await pool.execute(
      `SELECT id, noi_dung, loai
       FROM thong_bao
       WHERE nguoi_dung_id = ?
       ORDER BY ngay_tao DESC`,
      [userId]
    );

    res.json({
      success: true,
      notifications,
    });
  } catch (err) {
    console.error('Lỗi lấy thông báo:', err);
    res.status(500).json({
      success: false,
      message: 'Không thể lấy thông báo',
      notifications: [],
    });
  }
});

/**
 * =========================
 * NGÂN SÁCH THÁNG
 * =========================
 */

// Lấy ngân sách tháng hiện tại
router.get('/budget/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [rows] = await pool.execute(
      `SELECT so_tien_gioi_han
       FROM ngan_sach
       WHERE nguoi_dung_id = ?
         AND chu_ky = 'thang'
       ORDER BY ngay_tao DESC
       LIMIT 1`,
      [userId]
    );

    res.json({
      success: true,
      budget: rows.length > 0 ? rows[0].so_tien_gioi_han : null,
    });
  } catch (err) {
    console.error('Lỗi lấy ngân sách:', err);
    res.status(500).json({
      success: false,
      message: 'Không thể lấy ngân sách tháng',
      budget: null,
    });
  }
});

// Lưu / cập nhật ngân sách tháng
router.post('/budget', async (req, res) => {
  const { userId, so_tien_gioi_han } = req.body;

  if (!userId || !so_tien_gioi_han) {
    return res.status(400).json({
      success: false,
      message: 'Thiếu thông tin ngân sách',
    });
  }

  try {
    await pool.execute(
      `INSERT INTO ngan_sach
        (nguoi_dung_id, so_tien_gioi_han, chu_ky, ngay_bat_dau, ngay_tao)
       VALUES (?, ?, 'thang', CURDATE(), NOW())`,
      [userId, so_tien_gioi_han]
    );

    res.json({
      success: true,
      message: 'Lưu ngân sách thành công',
    });
  } catch (err) {
    console.error('Lỗi lưu ngân sách:', err);
    res.status(500).json({
      success: false,
      message: 'Không thể lưu ngân sách',
    });
  }
});
// 🔥 Xóa ngân sách tháng
router.delete('/budget/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    await pool.execute(
      `DELETE FROM ngan_sach 
       WHERE nguoi_dung_id = ? 
         AND chu_ky = 'thang'`,
      [userId]
    );

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

module.exports = router;
