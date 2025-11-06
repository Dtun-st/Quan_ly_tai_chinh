const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const pool = require('../db');

router.post('/', async (req, res) => {
  const { email_or_phone, password } = req.body;
  if (!email_or_phone || !password) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin đăng nhập' });
  }

  try {
    const [users] = await pool.execute(
      'SELECT * FROM nguoi_dung WHERE email = ? OR so_dien_thoai = ?',
      [email_or_phone, email_or_phone]
    );

    if (users.length == 0) {
      return res.status(400).json({ success: false, message: 'Tài khoản không tồn tại' });
    }

    const user = users[0];
    const match = await bcrypt.compare(password, user.mat_khau);
    if (!match) {
      return res.status(400).json({ success: false, message: 'Sai mật khẩu' });
    }

    res.json({ success: true, message: 'Đăng nhập thành công', user });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
