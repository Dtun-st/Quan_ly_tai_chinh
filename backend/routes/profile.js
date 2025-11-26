const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET /api/user/:userId
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT id, ho_ten AS name, email, so_dien_thoai AS phone, ngay_sinh AS birthday, gioi_tinh AS gender FROM nguoi_dung WHERE id=?',
      [userId]
    );

    if (rows.length === 0)
      return res.status(404).json({ success: false, message: "Người dùng không tồn tại" });

    res.json({ success: true, user: rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
});

module.exports = router;
