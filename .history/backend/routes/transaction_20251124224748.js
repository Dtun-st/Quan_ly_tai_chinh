// const express = require('express');
// const router = express.Router();
// const multer = require('multer');
// const path = require('path');
// const pool = require('../db'); // MySQL connection

// // --- Multer storage ---
// const storage = multer.diskStorage({
//   destination: (req, file, cb) => cb(null, 'uploads/'),
//   filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
// });
// const upload = multer({ storage });

// // --- Tạo giao dịch ---
// router.post('/', upload.single('billImage'), async (req, res) => {
//   const { userId, accountId, type, categoryName, amount, description, date } = req.body;
//   const billImage = req.file ? `/uploads/${req.file.filename}` : null;

//   if (!userId || !accountId || !type || !categoryName || !amount || !date)
//     return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

//   try {
//     await pool.execute(
//       `INSERT INTO transactions (user_id, account_id, type, category_name, amount, description, date, bill_image)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
//       [userId, accountId, type, categoryName, amount, description || '', date, billImage]
//     );
//     res.json({ success: true, message: 'Giao dịch lưu thành công' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// // --- Lấy tất cả giao dịch ---
// router.get('/:userId', async (req, res) => {
//   const { userId } = req.params;
//   try {
//     const [rows] = await pool.execute('SELECT * FROM transactions WHERE user_id=? ORDER BY date DESC', [userId]);
//     res.json(rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// // --- Cập nhật ---
// router.put('/:id', upload.single('billImage'), async (req, res) => {
//   const { id } = req.params;
//   const { accountId, type, categoryName, amount, description, date } = req.body;
//   const billImage = req.file ? `/uploads/${req.file.filename}` : null;

//   try {
//     const [result] = await pool.execute(
//       `UPDATE transactions SET account_id=?, type=?, category_name=?, amount=?, description=?, date=?, bill_image=COALESCE(?, bill_image)
//        WHERE id=?`,
//       [accountId, type, categoryName, amount, description || '', date, billImage, id]
//     );
//     if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
//     res.json({ success: true, message: 'Cập nhật thành công' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// // --- Xóa ---
// router.delete('/:id', async (req, res) => {
//   const { id } = req.params;
//   try {
//     const [result] = await pool.execute('DELETE FROM transactions WHERE id=?', [id]);
//     if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
//     res.json({ success: true, message: 'Đã xóa giao dịch' });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
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
  const { userId, taiKhoanId, danhMucId, loaiGd, soTien, moTa, ngayGd } = req.body;
  const anhHoaDon = req.file ? `/uploads/${req.file.filename}` : null;

  if (!userId || !taiKhoanId || !danhMucId || !loaiGd || !soTien || !ngayGd)
    return res.status(400).json({ success: false, message: 'Thiếu thông tin' });

  const parsedAmount = parseFloat(soTien);
  if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Lưu giao dịch
    await conn.execute(
      `INSERT INTO giao_dich
       (nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, taiKhoanId, danhMucId, loaiGd, parsedAmount, moTa || '', ngayGd, anhHoaDon]
    );

    // Cập nhật số dư tài khoản
    const [rows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [taiKhoanId]);
    if (!rows.length) throw new Error('Tài khoản không tồn tại');
    let currentBalance = parseFloat(rows[0].so_du);

    if (loaiGd === 'Chi') currentBalance -= parsedAmount;
    else if (loaiGd === 'Thu') currentBalance += parsedAmount;

    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [currentBalance, taiKhoanId]);

    await conn.commit();
    res.json({ success: true, message: 'Giao dịch lưu thành công' });
  } catch (err) {
    await conn.rollback();
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  } finally {
    conn.release();
  }
});

// --- Lấy tất cả giao dịch theo user ---
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      `SELECT gd.*, dm.ten_danh_muc, tk.ten_tai_khoan 
       FROM giao_dich gd
       JOIN danh_muc dm ON gd.danh_muc_id = dm.id
       JOIN tai_khoan tk ON gd.tai_khoan_id = tk.id
       WHERE gd.nguoi_dung_id=? ORDER BY gd.ngay_giao_dich DESC`, 
      [userId]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// --- Cập nhật giao dịch ---
router.put('/:id', upload.single('billImage'), async (req, res) => {
  const { id } = req.params;
  const { taiKhoanId, danhMucId, loaiGd, soTien, moTa, ngayGd } = req.body;
  const anhHoaDon = req.file ? `/uploads/${req.file.filename}` : null;

  const parsedAmount = parseFloat(soTien);
  if (isNaN(parsedAmount)) return res.status(400).json({ success: false, message: 'Số tiền không hợp lệ' });

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Lấy giao dịch cũ
    const [oldRows] = await conn.execute('SELECT tai_khoan_id, loai_gd, so_tien FROM giao_dich WHERE id=?', [id]);
    if (!oldRows.length) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    const old = oldRows[0];

    // Hoàn tác số dư cũ
    const [accRows] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [old.tai_khoan_id]);
    let oldBalance = parseFloat(accRows[0].so_du);
    if (old.loai_gd === 'Chi') oldBalance += parseFloat(old.so_tien);
    else oldBalance -= parseFloat(old.so_tien);
    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [oldBalance, old.tai_khoan_id]);

    // Cập nhật giao dịch
    await conn.execute(
      `UPDATE giao_dich SET 
       tai_khoan_id=?, danh_muc_id=?, loai_gd=?, so_tien=?, mo_ta=?, ngay_giao_dich=?, anh_hoa_don=COALESCE(?, anh_hoa_don)
       WHERE id=?`,
      [taiKhoanId, danhMucId, loaiGd, parsedAmount, moTa || '', ngayGd, anhHoaDon, id]
    );

    // Cập nhật số dư mới
    const [newAcc] = await conn.execute('SELECT so_du FROM tai_khoan WHERE id=?', [taiKhoanId]);
    let newBalance = parseFloat(newAcc[0].so_du);
    if (loaiGd === 'Chi') newBalance -= parsedAmount;
    else newBalance += parsedAmount;
    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [newBalance, taiKhoanId]);

    await conn.commit();
    res.json({ success: true, message: 'Cập nhật thành công' });
  } catch (err) {
    await conn.rollback();
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  } finally {
    conn.release();
  }
});

// --- Xóa giao dịch ---
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.execute('SELECT tai_khoan_id, loai_gd, so_tien FROM giao_dich WHERE id=?', [id]);
    if (!rows.length) return res.status(404).json({ success: false, message: 'Giao dịch không tồn tại' });
    const trans = rows[0];

    // Hoàn tác số dư
    const [accRows] = await pool.execute('SELECT so_du FROM tai_khoan WHERE id=?', [trans.tai_khoan_id]);
    let balance = parseFloat(accRows[0].so_du);
    if (trans.loai_gd === 'Chi') balance += parseFloat(trans.so_tien);
    else balance -= parseFloat(trans.so_tien);
    await pool.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [balance, trans.tai_khoan_id]);

    // Xóa giao dịch
    await pool.execute('DELETE FROM giao_dich WHERE id=?', [id]);
    res.json({ success: true, message: 'Đã xóa giao dịch' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
