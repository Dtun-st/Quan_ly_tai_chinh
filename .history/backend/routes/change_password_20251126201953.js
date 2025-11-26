const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcrypt');

// Đổi mật khẩu
router.post('/change', async (req, res) => {
  const { userId, oldPassword, newPassword } = req.body;

  if (!userId || !oldPassword || !newPassword) {
    return res.json({ success: false, message: "Thiếu dữ liệu" });
  }

  try {
    const [rows] = await pool.execute(
      "SELECT mat_khau FROM nguoi_dung WHERE id = ?",
      [userId]
    );

    if (rows.length === 0)
      return res.json({ success: false, message: "Tài khoản không tồn tại" });

    const hash = rows[0].mat_khau;

    // Kiểm tra mật khẩu cũ đúng không
    const match = await bcrypt.compare(oldPassword, hash);
    if (!match)
      return res.json({ success: false, message: "Mật khẩu cũ không chính xác" });

    // Hash mật khẩu mới
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
    console.log(err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
});

module.exports = router;
