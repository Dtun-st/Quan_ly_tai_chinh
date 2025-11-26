const express = require('express');
const router = express.Router();
const multer = require('multer');
const pool = require('../db');

// Setup multer for file upload
const storage = multer.memoryStorage();
const upload = multer({ storage });

router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM transactions WHERE user_id = ? ORDER BY date DESC',
      [userId]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

router.post('/', upload.single('image'), async (req, res) => {
  const { userId, accountId, type, categoryName, amount, description, date } = req.body;
  let imageData = null;

  if (req.file) {
    imageData = req.file.buffer.toString('base64'); // lưu Base64
  }

  try {
    await pool.execute(
      `INSERT INTO transactions 
       (user_id, account_id, type, category_name, amount, description, date, image) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, type, categoryName, amount, description, date, imageData]
    );
    res.json({ success: true, message: 'Giao dịch lưu thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
