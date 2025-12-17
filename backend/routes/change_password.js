const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcrypt');

router.post('/change', async (req, res) => {
  const { userId, oldPassword, newPassword } = req.body;

  // ===== VALIDATE =====
  if (!userId || !oldPassword || !newPassword) {
    return res.json({
      success: false,
      message: "Vui lòng nhập đầy đủ thông tin"
    });
  }

  if (newPassword.length < 6) {
    return res.json({
      success: false,
      message: "Mật khẩu mới phải có ít nhất 6 ký tự"
    });
  }

  try {
    const [rows] = await pool.execute(
      "SELECT mat_khau FROM nguoi_dung WHERE id = ?",
      [userId]
    );

    if (rows.length === 0) {
      return res.json({
        success: false,
        message: "Tài khoản không tồn tại"
      });
    }

    const isMatch = await bcrypt.compare(oldPassword, rows[0].mat_khau);
    if (!isMatch) {
      return res.json({
        success: false,
        message: "Mật khẩu cũ không chính xác"
      });
    }

    const newHash = await bcrypt.hash(newPassword, 10);

    await pool.execute(
      "UPDATE nguoi_dung SET mat_khau = ? WHERE id = ?",
      [newHash, userId]
    );

    return res.json({
      success: true,
      message: "Đổi mật khẩu thành công"
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: "Lỗi server"
    });
  }
});

module.exports = router;
