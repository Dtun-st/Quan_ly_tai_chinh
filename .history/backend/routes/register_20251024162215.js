const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const pool = require('../db'); // Kết nối MySQL từ db.js

// POST /register
router.post('/', async (req, res) => {
  const { ho_ten, email, so_dien_thoai, mat_khau } = req.body;

  if (!ho_ten || !email || !so_dien_thoai || !mat_khau) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin đăng ký' });
  }

  try {
    // Kiểm tra email hoặc số điện thoại đã tồn tại chưa
    const [existing] = await pool.execute(
      'SELECT * FROM nguoi_dung WHERE email = ? OR so_dien_thoai = ?',
      [email, so_dien_thoai]
    );
    if (existing.length > 0) {
      return res.status(400).json({ success: false, message: 'Email hoặc số điện thoại đã tồn tại' });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(mat_khau, 10);

    // Thêm người dùng vào DB
    await pool.execute(
      'INSERT INTO nguoi_dung (ho_ten, email, so_dien_thoai, mat_khau) VALUES (?, ?, ?, ?)',
      [ho_ten, email, so_dien_thoai, hashedPassword]
    );

    res.json({ success: true, message: 'Đăng ký thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
