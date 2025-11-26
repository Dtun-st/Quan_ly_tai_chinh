const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT id, ten_tai_khoan, loai_tai_khoan, so_du FROM tai_khoan WHERE nguoi_dung_id = ?',
      [userId]
    );
    res.json({ success: true, accounts: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy tài khoản' });
  }
});

router.post('/', async (req, res) => {
  const { nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
  try {
    await pool.execute(
      'INSERT INTO tai_khoan (nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du) VALUES (?, ?, ?, ?)',
      [nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du]
    );
    res.json({ success: true, message: 'Thêm tài khoản thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi khi thêm tài khoản' });
  }
});

router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await pool.execute('DELETE FROM tai_khoan WHERE id = ?', [id]);
    res.json({ success: true, message: 'Xóa tài khoản thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi khi xóa tài khoản' });
  }
});

module.exports = router;
