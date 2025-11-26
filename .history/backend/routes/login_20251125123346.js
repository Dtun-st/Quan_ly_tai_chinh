const express = require('express');
const router = express.Router();
const nodemailer = require('nodemailer');
const pool = require('../db'); // pool MySQL (giống file login)
const bcrypt = require('bcrypt');

// Cấu hình Nodemailer
const transporter = nodemailer.createTransport({
  service: 'Gmail',
  auth: {
    user: 'YOUR_EMAIL@gmail.com',
    pass: 'YOUR_APP_PASSWORD',
  },
});

// ==============================
// Route gửi mã OTP
// ==============================
router.post('/', async (req, res) => {
  const { email } = req.body;

  if (!email) return res.status(400).json({ success: false, message: 'Thiếu email' });

  try {
    const [users] = await pool.execute('SELECT * FROM nguoi_dung WHERE email=?', [email]);
    if (users.length === 0) return res.status(404).json({ success: false, message: 'Email không tồn tại' });

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expire = new Date(Date.now() + 15 * 60 * 1000); // 15 phút

    await pool.execute(
      'UPDATE nguoi_dung SET reset_code=?, reset_code_expire=? WHERE email=?',
      [code, expire, email]
    );

    const mailOptions = {
      from: 'YOUR_EMAIL@gmail.com',
      to: email,
      subject: 'Mã xác thực đặt lại mật khẩu',
      text: `Mã xác thực của bạn là: ${code}. Hết hạn trong 15 phút.`,
    };

    transporter.sendMail(mailOptions, (err, info) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ success: false, message: 'Gửi email thất bại' });
      }
      res.json({ success: true, message: 'Mã xác thực đã được gửi' });
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// ==============================
// Route reset password
// ==============================
router.post('/reset', async (req, res) => {
  const { email, code, newPassword } = req.body;

  if (!email || !code || !newPassword) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });
  }

  try {
    const [users] = await pool.execute('SELECT * FROM nguoi_dung WHERE email=?', [email]);
    if (users.length === 0) return res.status(404).json({ success: false, message: 'Email không tồn tại' });

    const user = users[0];

    if (user.reset_code !== code || new Date(user.reset_code_expire) < new Date()) {
      return res.status(400).json({ success: false, message: 'Mã xác thực không hợp lệ hoặc đã hết hạn' });
    }

    // Hash mật khẩu trước khi lưu
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    await pool.execute(
      'UPDATE nguoi_dung SET mat_khau=?, reset_code=NULL, reset_code_expire=NULL WHERE email=?',
      [hashedPassword, email]
    );

    res.json({ success: true, message: 'Đặt lại mật khẩu thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
