const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcrypt');

// Đăng ký người dùng
router.post('/', async (req, res) => {
  const { ho_ten, email, so_dien_thoai, mat_khau } = req.body;

  if (!ho_ten || !email || !so_dien_thoai || !mat_khau) {
    return res.status(400).json({ message: 'Vui lòng nhập đầy đủ thông tin' });
  }

  try {
    // Kiểm tra email hoặc số điện thoại đã tồn tại chưa
    const [existing] = await pool.query(
      'SELECT * FROM nguoi_dung WHERE email = ? OR so_dien_thoai = ?',
      [email, so_dien_thoai]
    );

    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email hoặc số điện thoại đã tồn tại' });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(mat_khau, 10);

    // Thêm vào database
    const [result] = await pool.query(
      'INSERT INTO nguoi_dung (ho_ten, email, so_dien_thoai, mat_khau) VALUES (?, ?, ?, ?)',
      [ho_ten, email, so_dien_thoai, hashedPassword]
    );

    res.json({ message: 'Đăng ký thành công', userId: result.insertId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Lỗi server' });
  }
});

module.exports = router;
