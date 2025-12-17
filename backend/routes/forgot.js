const express = require('express');
const router = express.Router();
const pool = require('../db'); 
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');

// =====================
// Cấu hình gửi email
// =====================
const transporter = nodemailer.createTransport({
  service: 'Gmail',
  auth: {
    user: 'nguyenduytung642003@gmail.com',
    pass: 'payrrjavhvgwbkpf',
  },
  tls: {
    rejectUnauthorized: false,
  },
});

// =====================
// Hàm kiểm tra định dạng email
// =====================
function isValidEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

// =====================
// Gửi mã OTP
// =====================
router.post('/', async (req, res) => {
  let email = (req.body.email || '').toString().trim();

  if (!email) {
    return res.status(400).json({ success: false, message: 'Vui lòng cung cấp email' });
  }

  if (!isValidEmail(email)) {
    return res.status(400).json({ success: false, message: 'Email không hợp lệ' });
  }

  try {
    const [users] = await pool.execute('SELECT * FROM nguoi_dung WHERE email=?', [email]);
    if (users.length === 0) {
      return res.status(404).json({ success: false, message: 'Email này chưa được đăng ký' });
    }

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expire = new Date(Date.now() + 15 * 60 * 1000);

    await pool.execute(
      'UPDATE nguoi_dung SET reset_code=?, reset_code_expire=? WHERE email=?',
      [code, expire, email]
    );

    const mailOptions = {
      from: 'nguyenduytung060403@gmail.com',
      to: email,
      subject: 'Mã OTP khôi phục mật khẩu',
      text: `Mã OTP của bạn là: ${code}. Mã có hiệu lực trong 15 phút.`,
    };

    transporter.sendMail(mailOptions, (err) => {
      if (err) {
        console.error('Lỗi gửi email:', err);
        return res.status(500).json({ success: false, message: 'Gửi email thất bại, vui lòng thử lại sau' });
      }
      res.json({ success: true, message: 'Mã OTP đã được gửi đến email của bạn' });
    });
  } catch (err) {
    console.error('Lỗi server khi gửi OTP:', err);
    res.status(500).json({ success: false, message: 'Có lỗi xảy ra, vui lòng thử lại sau' });
  }
});

// =====================
// Reset mật khẩu
// =====================
router.post('/reset', async (req, res) => {
  let email = (req.body.email || '').toString().trim();
  const { code, newPassword } = req.body;

  if (!email || !code || !newPassword) {
    return res.status(400).json({ success: false, message: 'Vui lòng cung cấp đầy đủ thông tin email, mã OTP và mật khẩu mới' });
  }

  if (!isValidEmail(email)) {
    return res.status(400).json({ success: false, message: 'Email không hợp lệ' });
  }

  if (newPassword.length < 6) {
    return res.status(400).json({ success: false, message: 'Mật khẩu mới phải có ít nhất 6 ký tự' });
  }

  try {
    const [users] = await pool.execute('SELECT * FROM nguoi_dung WHERE email=?', [email]);
    if (users.length === 0) {
      return res.status(404).json({ success: false, message: 'Email này chưa được đăng ký' });
    }

    const user = users[0];
    if (user.reset_code !== code || new Date(user.reset_code_expire) < new Date()) {
      return res.status(400).json({ success: false, message: 'Mã OTP không hợp lệ hoặc đã hết hạn' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await pool.execute(
      'UPDATE nguoi_dung SET mat_khau=?, reset_code=NULL, reset_code_expire=NULL WHERE email=?',
      [hashedPassword, email]
    );

    res.json({ success: true, message: 'Mật khẩu của bạn đã được đặt lại thành công' });
  } catch (err) {
    console.error('❌ Lỗi server khi reset mật khẩu:', err);
    res.status(500).json({ success: false, message: 'Có lỗi xảy ra, vui lòng thử lại sau' });
  }
});

module.exports = router;
