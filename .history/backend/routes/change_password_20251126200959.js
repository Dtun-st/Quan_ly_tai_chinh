const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const pool = require('../db'); 

// POST /change-password
router.post('/change-password', async (req, res) => {
    const { user_id, old_password, new_password } = req.body;

    if (!user_id || !old_password || !new_password) {
        return res.status(400).json({ message: "Thiếu dữ liệu" });
    }

    try {
        // Lấy user hiện tại
        const [rows] = await pool.execute(
            "SELECT password FROM users WHERE id = ?",
            [user_id]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "User không tồn tại" });
        }

        const hashedPassword = rows[0].password;

        // Kiểm tra mật khẩu cũ
        const isMatch = await bcrypt.compare(old_password, hashedPassword);
        if (!isMatch) {
            return res.status(401).json({ message: "Mật khẩu cũ không đúng" });
        }

        // Hash mật khẩu mới
        const newHashed = await bcrypt.hash(new_password, 10);

        // Update mật khẩu
        await pool.execute(
            "UPDATE users SET password = ? WHERE id = ?",
            [newHashed, user_id]
        );

        res.json({ message: "Đổi mật khẩu thành công" });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Lỗi server" });
    }
});

module.exports = router;
