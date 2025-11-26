const express = require('express');
const router = express.Router();
const pool = require('../db'); // file pool MySQL bạn đã tạo

/**
 * POST /api/transaction
 * Thêm giao dịch mới
 */
router.post('/', async (req, res) => {
  const { nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

  if (!nguoiDungId || !taiKhoanId || !hanMucId || !loaiGd || !soTien || !ngayGiaoDich) {
    return res.status(400).json({ success: false, message: "Thiếu dữ liệu" });
  }

  try {
    const [result] = await pool.execute(
      `INSERT INTO giao_dich 
       (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa || '', ngayGiaoDich]
    );

    // Lấy transaction vừa thêm
    const [rows] = await pool.execute('SELECT * FROM giao_dich WHERE id = ?', [result.insertId]);
    res.json({ success: true, transaction: rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

/**
 * GET /api/transaction
 * Lấy danh sách tất cả giao dịch của user (optionally theo userId)
 */
router.get('/', async (req, res) => {
  const { nguoiDungId } = req.query;

  try {
    let query = 'SELECT * FROM giao_dich';
    let params = [];

    if (nguoiDungId) {
      query += ' WHERE nguoi_dung_id = ?';
      params.push(nguoiDungId);
    }

    query += ' ORDER BY ngay_giao_dich DESC';

    const [rows] = await pool.execute(query, params);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
