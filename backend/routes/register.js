const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const pool = require('../db');
const { insertDefaultCategories } = require('./category');

// POST /api/register
router.post('/', async (req, res) => {
  const { ho_ten, email, so_dien_thoai, mat_khau } = req.body;

  // 1. Validate bắt buộc
  if (!ho_ten || !email || !so_dien_thoai || !mat_khau) {
    return res.status(400).json({
      success: false,
      message: 'Vui lòng nhập đầy đủ họ tên, email, số điện thoại và mật khẩu',
    });
  }

  // 2. Validate mật khẩu
  if (mat_khau.length < 6) {
    return res.status(400).json({
      success: false,
      message: 'Mật khẩu phải có ít nhất 6 ký tự',
    });
  }

  try {
    // 3. Kiểm tra trùng email / SĐT
    const [existing] = await pool.execute(
      'SELECT id FROM nguoi_dung WHERE email = ? OR so_dien_thoai = ?',
      [email, so_dien_thoai]
    );

    if (existing.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'Email hoặc số điện thoại đã được sử dụng',
      });
    }

    // 4. Hash mật khẩu
    const hashedPassword = await bcrypt.hash(mat_khau, 10);

    // 5. Insert user
    const [result] = await pool.execute(
      'INSERT INTO nguoi_dung (ho_ten, email, so_dien_thoai, mat_khau) VALUES (?, ?, ?, ?)',
      [ho_ten, email, so_dien_thoai, hashedPassword]
    );

    // 6. Tạo danh mục mặc định
    await insertDefaultCategories(result.insertId);

    return res.status(201).json({
      success: true,
      message: 'Đăng ký thành công',
    });
  } catch (err) {
    console.error('REGISTER ERROR:', err);
    return res.status(500).json({
      success: false,
      message: 'Lỗi hệ thống, vui lòng thử lại sau',
    });
  }
});

module.exports = router;
