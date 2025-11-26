// // home.js
// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// // Lấy danh sách tài khoản của user
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

// // Lấy giao dịch gần đây
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

// // Lấy thông báo của user
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


// module.exports = router;
// home.js
const express = require('express');
const router = express.Router();
const pool = require('../db');

// Lấy danh sách tài khoản của user
router.get('/tai_khoan/:userId', async (req, res) => {
  const userId = req.params.userId;
  try {
    const [accounts] = await pool.execute(
      'SELECT id, ten_tai_khoan AS ten, loai_tai_khoan AS loai, so_du FROM tai_khoan WHERE nguoi_dung_id = ?',
      [userId]
    );
    res.json({ accounts });
  } catch (err) {
    console.error(err);
    res.status(500).json({ accounts: [] });
  }
});

// Lấy giao dịch gần đây
router.get('/giao_dich/:userId', async (req, res) => {
  const userId = req.params.userId;
  try {
    const [transactions] = await pool.execute(
      `SELECT gd.id, gd.so_tien, gd.loai_gd AS loai, gd.ngay_giao_dich AS ngay, dm.ten_danh_muc AS han_muc
       FROM giao_dich gd
       JOIN danh_muc dm ON gd.danh_muc_id = dm.id
       WHERE gd.nguoi_dung_id = ?
       ORDER BY gd.ngay_giao_dich DESC
       LIMIT 20`,
      [userId]
    );
    res.json({ transactions });
  } catch (err) {
    console.error(err);
    res.status(500).json({ transactions: [] });
  }
});

// Lấy thông báo
router.get('/thong_bao/:userId', async (req, res) => {
  const userId = req.params.userId;
  try {
    const [notifications] = await pool.execute(
      'SELECT id, noi_dung, loai, da_doc, ngay_tao FROM thong_bao WHERE nguoi_dung_id = ? ORDER BY ngay_tao DESC',
      [userId]
    );
    res.json({ notifications });
  } catch (err) {
    console.error(err);
    res.status(500).json({ notifications: [] });
  }
});

// ----------------- Ngân sách -----------------
// Lấy ngân sách
router.get('/budget/:userId', async (req, res) => {
  const userId = req.params.userId;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM budget WHERE nguoi_dung_id = ? ORDER BY ngay_tao DESC LIMIT 1',
      [userId]
    );
    if (rows.length > 0) {
      res.json({ budget: rows[0] });
    } else {
      res.json({ budget: null });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ budget: null });
  }
});

// Lưu / Cập nhật ngân sách
router.post('/budget', async (req, res) => {
  const { userId, so_tien, chu_ky, ngay_bat_dau, ngay_ket_thuc } = req.body;

  if (!userId || so_tien == null || !chu_ky || !ngay_bat_dau) {
    return res.status(400).json({ success: false, message: "Thiếu thông tin" });
  }

  try {
    // Thêm mới ngân sách
    await pool.execute(
      `INSERT INTO budget 
        (nguoi_dung_id, so_tien, chu_ky, ngay_bat_dau, ngay_ket_thuc) 
       VALUES (?, ?, ?, ?, ?)`,
      [userId, so_tien, chu_ky, ngay_bat_dau, ngay_ket_thuc || null]
    );

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

module.exports = router;
