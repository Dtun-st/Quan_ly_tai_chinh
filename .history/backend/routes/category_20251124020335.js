const express = require('express');
const router = express.Router();
const pool = require('../db');
// Lấy danh mục theo user
router.get('/', async (req, res) => {
  const { userId, type } = req.query;
  try {
    // Lấy danh mục cha (parent_id NULL hoặc 0)
    const [parents] = await pool.query(
      'SELECT * FROM danh_muc WHERE loai = ? AND nguoi_dung_id = ? AND (parent_id IS NULL OR parent_id = 0)',
      [type, userId]
    );

    const categories = [];

    for (let parent of parents) {
      // Lấy danh mục con
      const [children] = await pool.query(
        'SELECT * FROM danh_muc WHERE parent_id = ? AND nguoi_dung_id = ?',
        [parent.id, userId]
      );

      categories.push({
        id: parent.id,
        name: parent.ten_danh_muc || "", // ✅ đảm bảo cha có tên
        icon: parent.icon,
        children: children.map(c => ({
          id: c.id,
          name: c.ten_danh_muc || "", // ✅ đảm bảo con có tên
          icon: c.icon
        }))
      });
    }

    res.json(categories);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});


// Thêm danh mục cha
router.post('/', async (req, res) => {
  const { userId, name, type, icon } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
      [name, type, icon, userId, null]
    );
    res.json({ id: result.insertId, name, type, icon });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// Thêm danh mục con
router.post('/:parentId/children', async (req, res) => {
  const { parentId } = req.params;
  const { userId, name, icon } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?, ?)',
      [name, 'Chi', icon, parentId, userId]
    );
    res.json({ id: result.insertId, name, icon });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});
// Sửa danh mục (cha hoặc con)
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, icon } = req.body;

  try {
    await pool.query(
      'UPDATE danh_muc SET ten_danh_muc = ?, icon = ? WHERE id = ?',
      [name, icon, id]
    );
    res.json({ id, name, icon });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});
// Xóa danh mục
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    // Xóa luôn các danh mục con nếu là danh mục cha
    await pool.query('DELETE FROM danh_muc WHERE parent_id = ?', [id]);
    // Xóa danh mục chính
    await pool.query('DELETE FROM danh_muc WHERE id = ?', [id]);

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});


module.exports = router;
