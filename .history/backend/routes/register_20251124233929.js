// const express = require('express');
// const router = express.Router();
// const bcrypt = require('bcrypt');
// const pool = require('../db');
// const insertDefaultCategories = require('./category').insertDefaultCategories; // chỉ lấy hàm

// // POST /register
// router.post('/', async (req, res) => {
//   const { ho_ten, email, so_dien_thoai, mat_khau } = req.body;

//   if (!ho_ten || !email || !so_dien_thoai || !mat_khau) {
//     return res.status(400).json({ success: false, message: 'Thiếu thông tin đăng ký' });
//   }

//   try {
//     // Kiểm tra tồn tại email hoặc số điện thoại
//     const [existing] = await pool.execute(
//       'SELECT * FROM nguoi_dung WHERE email = ? OR so_dien_thoai = ?',
//       [email, so_dien_thoai]
//     );
//     if (existing.length > 0) {
//       return res.status(400).json({ success: false, message: 'Email hoặc số điện thoại đã tồn tại' });
//     }

//     // Hash mật khẩu
//     const hashedPassword = await bcrypt.hash(mat_khau, 10);

//     // Thêm user mới
//     const [result] = await pool.execute(
//       'INSERT INTO nguoi_dung (ho_ten, email, so_dien_thoai, mat_khau) VALUES (?, ?, ?, ?)',
//       [ho_ten, email, so_dien_thoai, hashedPassword]
//     );

//     // Lấy userId vừa tạo
//     const userId = result.insertId;

//     // Chèn dữ liệu danh mục mẫu cho user này
//     await insertDefaultCategories(userId);

//     res.json({ success: true, message: 'Đăng ký thành công' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const pool = require('../db');

// Import từ category.js
const { insertDefaultCategories } = require('./category');

// POST /register
router.post('/', async (req, res) => {
  const { ho_ten, email, so_dien_thoai, mat_khau } = req.body;

  if (!ho_ten || !email || !so_dien_thoai || !mat_khau) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin đăng ký' });
  }

  try {
    // Kiểm tra tồn tại email hoặc số điện thoại
    const [existing] = await pool.execute(
      'SELECT * FROM nguoi_dung WHERE email = ? OR so_dien_thoai = ?',
      [email, so_dien_thoai]
    );
    if (existing.length > 0) {
      return res.status(400).json({ success: false, message: 'Email hoặc số điện thoại đã tồn tại' });
    }

    // Hash mật khẩu
    const hashedPassword = await bcrypt.hash(mat_khau, 10);

    // Thêm user mới
    const [result] = await pool.execute(
      'INSERT INTO nguoi_dung (ho_ten, email, so_dien_thoai, mat_khau) VALUES (?, ?, ?, ?)',
      [ho_ten, email, so_dien_thoai, hashedPassword]
    );

    // Lấy userId vừa tạo
    const userId = result.insertId;

    // Chèn dữ liệu danh mục mẫu cho user này
    await insertDefaultCategories(userId);

    res.json({ success: true, message: 'Đăng ký thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
