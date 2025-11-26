const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const pool = require('../db');

// --- Multer storage ---
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// --- Thêm giao dịch ---
router.post('/', upload.single('billImage'), async (req, res) => {
  console.log('--- POST /transaction ---');
  console.log('req.body:', req.body);
  console.log('req.file:', req.file);

  const { userId, accountId, danhMucId, type, amount, description, date } = req.body;
  const billImage = req.file ? `/uploads/${req.file.filename}` : null;

  if (!userId || !accountId || !danhMucId || !type || !amount || !date)
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Lưu giao dịch
    await conn.execute(
      `INSERT INTO giao_dich
       (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, accountId, danhMucId, type, parsedAmount, description || '', date, billImage]
    );

    // Cập nhật số dư tài khoản
    const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [accountId]);
    if (!rows.length) throw new Error('Tài khoản không tồn tại');
    let currentBalance = parseFloat(rows[0].so_du);

    if (type === 'Chi') currentBalance -= parsedAmount;
    else if (type === 'Thu') currentBalance += parsedAmount;

    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, accountId]);

    await conn.commit();
    res.json({ success: true, message: 'Giao dịch lưu thành công' });
  } catch (err) {
    await conn.rollback();
    console.error('❌ Lỗi lưu giao dịch:', err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  } finally {
    conn.release();
  }
});

module.exports = router;
