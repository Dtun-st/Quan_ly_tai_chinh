const express = require('express');
const router = express.Router();
const pool = require('../db'); // Chỉ khai báo 1 lần

// ======================
// ROUTES DANH MỤC
// ======================

// Lấy danh mục theo user
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM danh_muc WHERE nguoi_dung_id=?',
      [userId]
    );
    res.json({ success: true, categories: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Thêm danh mục
router.post('/', async (req, res) => {
  const { nguoi_dung_id, ten_danh_muc, loai, parent_id } = req.body;

  if (!nguoi_dung_id) {
    return res.status(400).json({ success: false, message: "Thiếu nguoi_dung_id" });
  }

  try {
    await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?)',
      [ten_danh_muc, loai, parent_id ?? null, nguoi_dung_id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Sửa danh mục
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { ten_danh_muc, icon } = req.body;

  try {
    const [rows] = await pool.execute(
      'SELECT nguoi_dung_id FROM danh_muc WHERE id=?',
      [id]
    );

    if (rows.length === 0)
      return res.status(404).json({ success: false, message: "Không tìm thấy danh mục" });

    if (!rows[0].nguoi_dung_id)
      return res.status(403).json({ success: false, message: "Danh mục hệ thống không được sửa" });

    await pool.execute(
      'UPDATE danh_muc SET ten_danh_muc=?, icon=? WHERE id=?',
      [ten_danh_muc, icon, id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Xóa danh mục
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT nguoi_dung_id FROM danh_muc WHERE id=?',
      [id]
    );

    if (rows.length === 0)
      return res.status(404).json({ success: false, message: "Không tìm thấy danh mục" });

    if (!rows[0].nguoi_dung_id)
      return res.status(403).json({ success: false, message: "Danh mục hệ thống không được xóa" });

    await pool.execute('DELETE FROM danh_muc WHERE id=?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// ======================
// HÀM SERVICE
// ======================
async function insertDefaultCategories(userId) {
  const defaultCategories = [
    { ten_danh_muc: 'Ăn uống', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Mua sắm', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Nhà cửa', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Thu nhập', loai: 'Thu', parent_id: null },
  ];

  for (const cat of defaultCategories) {
    await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?)',
      [cat.ten_danh_muc, cat.loai, cat.parent_id, userId]
    );
  }
}

// ======================
// EXPORT
// ======================
module.exports = {
  router,
  insertDefaultCategories
};
