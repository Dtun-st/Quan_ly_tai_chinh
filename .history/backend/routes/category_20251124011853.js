const express = require('express');
const router = express.Router();
const pool = require('../db');

// Lấy danh mục theo user
router.get('/', async (req, res) => {
  const { userId, type } = req.query;
  try {
    const [parents] = await pool.query(
      'SELECT * FROM danh_muc WHERE loai = ? AND nguoi_dung_id = ?',
      [type, userId]
    );

    const categories = [];
    for (let parent of parents) {
      const [children] = await pool.query(
        'SELECT * FROM danh_muc WHERE parent_id = ? AND nguoi_dung_id = ?',
        [parent.id, userId]
      );
      categories.push({
        id: parent.id,
        ten_danh_muc: parent.ten_danh_muc,
        icon: parent.icon,
        children: children.map(c => ({
          id: c.id,
          name: c.ten_danh_muc,
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
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id) VALUES (?, ?, ?, ?)',
      [name, type, icon, userId]
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

module.exports = router;
