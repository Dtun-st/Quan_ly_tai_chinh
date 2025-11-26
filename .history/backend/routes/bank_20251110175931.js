const express = require('express');
const router = express.Router();
const pool = require('../db'); // kết nối MySQL

// Lấy danh sách tài khoản của 1 user
router.get('/accounts/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM tai_khoan WHERE nguoi_dung_id = ?',
      [userId]
    );
    res.json({ success: true, accounts: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Thêm tài khoản
router.post('/accounts', async (req, res) => {
  const { nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
  if (!nguoi_dung_id || !ten_tai_khoan || !loai_tai_khoan || so_du == null) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu' });
  }

  try {
    const [result] = await pool.execute(
      'INSERT INTO tai_khoan (nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du) VALUES (?, ?, ?, ?)',
      [nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du]
    );
    // Trả về account vừa tạo
    const [rows] = await pool.execute('SELECT * FROM tai_khoan WHERE id = ?', [result.insertId]);
    res.json({ success: true, account: rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Sửa tài khoản
router.put('/accounts/:id', async (req, res) => {
  const { id } = req.params;
  const { ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
  if (!ten_tai_khoan || !loai_tai_khoan || so_du == null) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu' });
  }

  try {
    await pool.execute(
      'UPDATE tai_khoan SET ten_tai_khoan = ?, loai_tai_khoan = ?, so_du = ? WHERE id = ?',
      [ten_tai_khoan, loai_tai_khoan, so_du, id]
    );
    const [rows] = await pool.execute('SELECT * FROM tai_khoan WHERE id = ?', [id]);
    res.json({ success: true, account: rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Xóa tài khoản
router.delete('/accounts/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await pool.execute('DELETE FROM tai_khoan WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
