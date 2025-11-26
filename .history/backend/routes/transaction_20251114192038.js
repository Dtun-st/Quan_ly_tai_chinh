const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
  const userId = req.query.userId;
  if (!userId) return res.status(400).json({ success: false, message: 'Thiếu userId' });

  try {
    const [rows] = await pool.execute(
      'SELECT * FROM giao_dich WHERE nguoi_dung_id = ? ORDER BY ngay_giao_dich DESC',
      [userId]
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error("GET transactions error:", err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

router.get('/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const [rows] = await pool.execute('SELECT * FROM giao_dich WHERE id = ?', [id]);
    if (rows.length === 0)
      return res.status(404).json({ success: false, message: 'Không tìm thấy giao dịch' });
    res.json({ success: true, data: rows[0] });
  } catch (err) {
    console.error("GET one transaction error:", err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

router.post('/', async (req, res) => {
  let { nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

  if (!nguoiDungId || !taiKhoanId || !hanMucId || !loaiGd || !soTien || !ngayGiaoDich) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu bắt buộc' });
  }

  try {
    const [result] = await pool.execute(
      `INSERT INTO giao_dich 
      (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
      VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa || '', ngayGiaoDich]
    );

    res.json({ success: true, data: { id: result.insertId } });
  } catch (err) {
    console.error("POST transaction error:", err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

router.put('/:id', async (req, res) => {
  const id = Number(req.params.id);
  let { loaiGd, moTa, soTien, ngayGiaoDich } = req.body;

  soTien = Number(soTien);
  if (!loaiGd || !soTien || !ngayGiaoDich) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu (loai_gd, so_tien, ngay_giao_dich)' });
  }

  try {
    const [result] = await pool.execute(
      `UPDATE giao_dich 
       SET loai_gd=?, mo_ta=?, so_tien=?, ngay_giao_dich=?
       WHERE id=?`,
      [loaiGd, moTa || '', soTien, ngayGiaoDich, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    }

    res.json({ success: true, message: 'Cập nhật thành công' });
  } catch (err) {
    console.error("Update transaction error:", err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

router.delete('/:id', async (req, res) => {
  const id = Number(req.params.id);
  try {
    const [result] = await pool.execute('DELETE FROM giao_dich WHERE id=?', [id]);
    if (result.affectedRows === 0)
      return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    res.json({ success: true, message: 'Xóa thành công' });
  } catch (err) {
    console.error("Delete transaction error:", err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
