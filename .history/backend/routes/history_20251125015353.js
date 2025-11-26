const express = require('express');
const router = express.Router();
const pool = require('../db');

// Xóa giao dịch
router.delete('/:id', async (req, res) => {
  const id = req.params.id;
  try {
    await pool.execute('DELETE FROM giao_dich WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Sửa giao dịch
router.put('/:id', async (req, res) => {
  const id = req.params.id;
  const { so_tien } = req.body;
  try {
    await pool.execute('UPDATE giao_dich SET so_tien = ? WHERE id = ?', [so_tien, id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

module.exports = router;
