// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// // GET /api/profile/:userId
// router.get('/:userId', async (req, res) => {
//   try {
//     const { userId } = req.params;

//     const [rows] = await pool.execute(
//       `SELECT 
//         id,
//         ho_ten AS name,
//         email,
//         so_dien_thoai AS phone
//       FROM nguoi_dung
//       WHERE id = ?`,
//       [userId]
//     );

//     if (rows.length === 0) {
//       return res.status(404).json({ success: false, message: 'Người dùng không tồn tại' });
//     }

//     res.json({ success: true, user: rows[0] });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET /api/profile/:userId
router.get('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    const [rows] = await pool.execute(
      `SELECT 
        id,
        ho_ten AS name,
        email,
        so_dien_thoai AS phone
      FROM nguoi_dung
      WHERE id = ?`,
      [userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Người dùng không tồn tại',
      });
    }

    res.json({
      success: true,
      user: rows[0],
    });
  } catch (err) {
    console.error('Profile GET error:', err);
    res.status(500).json({
      success: false,
      message: 'Lỗi server',
    });
  }
});

// PUT /api/profile/:userId
router.put('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { name, phone } = req.body;

    await pool.execute(
      `UPDATE nguoi_dung 
       SET ho_ten = ?, so_dien_thoai = ?
       WHERE id = ?`,
      [name, phone, userId]
    );

    res.json({
      success: true,
      message: 'Cập nhật thông tin thành công',
    });
  } catch (err) {
    console.error('Profile UPDATE error:', err);
    res.status(500).json({
      success: false,
      message: 'Lỗi server',
    });
  }
});

module.exports = router;
