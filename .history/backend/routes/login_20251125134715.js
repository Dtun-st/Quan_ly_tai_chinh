const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcrypt');

router.post('/', async (req, res) => {
  const { email_or_phone, password } = req.body;

  if (!email_or_phone || !password)
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

  try {
    const [users] = await pool.execute(
      'SELECT * FROM nguoi_dung WHERE email=? OR so_dien_thoai=?',
      [email_or_phone, email_or_phone]
    );

    if (users.length === 0)
      return res.status(400).json({ success: false, message: 'Email/SDT hoặc mật khẩu không đúng' });

    const user = users[0];

    // So sánh mật khẩu hash
    const match = await bcrypt.compare(password, user.mat_khau);
    if (!match)
      return res.status(400).json({ success: false, message: 'Email/SDT hoặc mật khẩu không đúng' });

    // Nếu muốn trả token JWT, tạo ở đây
    res.json({
      success: true,
      message: 'Đăng nhập thành công',
      user: {
        id: user.id,
        ho_ten: user.ho_ten,
        email: user.email,
        so_dien_thoai: user.so_dien_thoai,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
