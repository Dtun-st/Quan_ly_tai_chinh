const express = require('express');
const router = express.Router();
const pool = require('../db');

// Lấy danh sách tài khoản theo userId
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [accounts] = await pool.execute(
      'SELECT * FROM tai_khoan WHERE nguoi_dung_id = ?',
      [userId]
    );
    res.json({ success: true, accounts });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Thêm tài khoản
router.post('/', async (req, res) => {
  const { nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
  try {
    await pool.execute(
      'INSERT INTO tai_khoan (nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du) VALUES (?, ?, ?, ?)',
      [nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Sửa tài khoản
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
  try {
    await pool.execute(
      'UPDATE tai_khoan SET ten_tai_khoan = ?, loai_tai_khoan = ?, so_du = ? WHERE id = ?',
      [ten_tai_khoan, loai_tai_khoan, so_du, id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// Xóa tài khoản
router.delete('/:id', async (req, res) => {
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
