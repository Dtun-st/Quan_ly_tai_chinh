// const express = require('express');
// const router = express.Router();
// const pool = require('../db'); // file pool MySQL bạn đã tạo

// /**
//  * POST /api/transaction
//  * Thêm giao dịch mới
//  */
// router.post('/', async (req, res) => {
//   const { nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

//   if (!nguoiDungId || !taiKhoanId || !hanMucId || !loaiGd || !soTien || !ngayGiaoDich) {
//     return res.status(400).json({ success: false, message: "Thiếu dữ liệu" });
//   }

//   try {
//     const [result] = await pool.execute(
//       `INSERT INTO giao_dich 
//        (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
//        VALUES (?, ?, ?, ?, ?, ?, ?)`,
//       [nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa || '', ngayGiaoDich]
//     );

//     // Lấy transaction vừa thêm
//     const [rows] = await pool.execute('SELECT * FROM giao_dich WHERE id = ?', [result.insertId]);
//     res.json({ success: true, transaction: rows[0] });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// /**
//  * GET /api/transaction
//  * Lấy danh sách tất cả giao dịch của user (optionally theo userId)
//  */
// router.get('/', async (req, res) => {
//   const { nguoiDungId } = req.query;

//   try {
//     let query = 'SELECT * FROM giao_dich';
//     let params = [];

//     if (nguoiDungId) {
//       query += ' WHERE nguoi_dung_id = ?';
//       params.push(nguoiDungId);
//     }

//     query += ' ORDER BY ngay_giao_dich DESC';

//     const [rows] = await pool.execute(query, params);
//     res.json(rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
// routes/transaction.js
const express = require('express');
const router = express.Router();
const mysql = require('mysql2/promise');
require('dotenv').config();

// Kết nối MySQL
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

// Lấy danh sách giao dịch theo userId
router.get('/:userId', async (req, res) => {
  try {
    const userId = parseInt(req.params.userId);
    const [rows] = await pool.query(
      `SELECT g.id, g.so_tien AS amount, g.mo_ta AS desc, g.loai_gd AS type, g.ngay_giao_dich AS date,
              g.tai_khoan_id AS accountId, g.han_muc_id AS categoryId
       FROM giao_dich g
       WHERE g.nguoi_dung_id = ?`,
      [userId]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Thêm giao dịch mới
router.post('/', async (req, res) => {
  try {
    const { nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;
    const [result] = await pool.query(
      `INSERT INTO giao_dich (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich]
    );
    res.json({ success: true, id: result.insertId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Cập nhật giao dịch
router.put('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const { taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;
    await pool.query(
      `UPDATE giao_dich
       SET tai_khoan_id=?, han_muc_id=?, loai_gd=?, so_tien=?, mo_ta=?, ngay_giao_dich=?
       WHERE id=?`,
      [taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich, id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Xóa giao dịch
router.delete('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    await pool.query(`DELETE FROM giao_dich WHERE id=?`, [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
