const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const pool = require('../db'); // MySQL connection

// --- Multer storage ---
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// --- Tạo giao dịch ---
router.post('/', upload.single('billImage'), async (req, res) => {
  const { userId, accountId, type, categoryName, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  if (!userId || !accountId || !type || !categoryName || !amount || !date)
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

  try {
    await pool.execute(
      `INSERT INTO transactions (user_id, account_id, type, category_name, amount, description, date, bill_image)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, type, categoryName, amount, description || '', date, billImage]
    );
    res.json({ success: true, message: 'Giao dịch lưu thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// --- Lấy tất cả giao dịch ---
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute('SELECT * FROM transactions WHERE user_id=? ORDER BY date DESC', [userId]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// --- Cập nhật ---
router.put('/:id', upload.single('billImage'), async (req, res) => {
  const { id } = req.params;
  const { accountId, type, categoryName, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  try {
    const [result] = await pool.execute(
      `UPDATE transactions SET account_id=?, type=?, category_name=?, amount=?, description=?, date=?, bill_image=COALESCE(?, bill_image)
       WHERE id=?`,
      [accountId, type, categoryName, amount, description || '', date, billImage, id]
    );
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    res.json({ success: true, message: 'Cập nhật thành công' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// --- Xóa ---
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await pool.execute('DELETE FROM transactions WHERE id=?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    res.json({ success: true, message: 'Đã xóa giao dịch' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
