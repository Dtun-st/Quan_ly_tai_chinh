const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const { sql, poolPromise } = require('../db');

// POST /register
router.post('/', async (req, res) => {
  try {
    const { ho_ten, email, so_dien_thoai, mat_khau, ngay_sinh, gioi_tinh, anh_dai_dien } = req.body;

    if (!ho_ten || !email || !so_dien_thoai || !mat_khau) {
      return res.status(400).json({ message: "Vui lòng nhập đầy đủ thông tin" });
    }

    const pool = await poolPromise;

    // Kiểm tra email hoặc số điện thoại đã tồn tại chưa
    const checkQuery = `SELECT * FROM nguoi_dung WHERE email=@Email OR so_dien_thoai=@Phone`;
    const result = await pool.request()
      .input('Email', sql.NVarChar, email)
      .input('Phone', sql.NVarChar, so_dien_thoai)
      .query(checkQuery);

    if (result.recordset.length > 0) {
      return res.status(400).json({ message: "Email hoặc số điện thoại đã tồn tại" });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(mat_khau, 10);

    // Thêm user
    const insertQuery = `
      INSERT INTO nguoi_dung (ho_ten, email, so_dien_thoai, mat_khau, ngay_sinh, gioi_tinh, anh_dai_dien)
      VALUES (@HoTen, @Email, @Phone, @Password, @NgaySinh, @GioiTinh, @Anh)
    `;

    await pool.request()
      .input('HoTen', sql.NVarChar, ho_ten)
      .input('Email', sql.NVarChar, email)
      .input('Phone', sql.NVarChar, so_dien_thoai)
      .input('Password', sql.NVarChar, hashedPassword)
      .input('NgaySinh', sql.Date, ngay_sinh || null)
      .input('GioiTinh', sql.NVarChar, gioi_tinh || null)
      .input('Anh', sql.NVarChar, anh_dai_dien || null)
      .query(insertQuery);

    res.json({ message: "Đăng ký thành công" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Lỗi server" });
  }
});

module.exports = router;
