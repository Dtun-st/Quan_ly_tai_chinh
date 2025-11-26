// const express = require('express');
// const router = express.Router();
// const pool = require('../db'); // file pool MySQL bạn đã tạo

// /**
//  * POST /api/transaction
//  * Thêm giao dịch mới
//  */
// router.post('/', async (req, res) => {
//   const { nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

//   if (!nguoiDungId || !taiKhoanId || !hanMucId || !loaiGd || !soTien || !ngayGiaoDich) {
//     return res.status(400).json({ success: false, message: "Thiếu dữ liệu" });
//   }

//   try {
//     const [result] = await pool.execute(
//       `INSERT INTO giao_dich 
//        (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
//        VALUES (?, ?, ?, ?, ?, ?, ?)`,
//       [nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa || '', ngayGiaoDich]
//     );

//     // Lấy transaction vừa thêm
//     const [rows] = await pool.execute('SELECT * FROM giao_dich WHERE id = ?', [result.insertId]);
//     res.json({ success: true, transaction: rows[0] });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// /**
//  * GET /api/transaction
//  * Lấy danh sách tất cả giao dịch của user (optionally theo userId)
//  */
// router.get('/', async (req, res) => {
//   const { nguoiDungId } = req.query;

//   try {
//     let query = 'SELECT * FROM giao_dich';
//     let params = [];

//     if (nguoiDungId) {
//       query += ' WHERE nguoi_dung_id = ?';
//       params.push(nguoiDungId);
//     }

//     query += ' ORDER BY ngay_giao_dich DESC';

//     const [rows] = await pool.execute(query, params);
//     res.json(rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
// routes/transaction.js
const express = require('express');
const router = express.Router();

// Giả lập dữ liệu tạm thời
let transactions = [];
let currentId = 1;

// Lấy danh sách giao dịch theo user
router.get('/:userId', (req, res) => {
  const userId = parseInt(req.params.userId);
  const userTx = transactions.filter(tx => tx.nguoiDungId === userId);
  res.json(userTx);
});

// Thêm giao dịch mới
router.post('/', (req, res) => {
  const tx = {
    id: currentId++,
    nguoiDungId: req.body.nguoiDungId,
    taiKhoanId: req.body.taiKhoanId,
    hanMucId: req.body.hanMucId,
    type: req.body.loaiGd,
    amount: req.body.soTien,
    desc: req.body.moTa,
    date: req.body.ngayGiaoDich,
  };
  transactions.push(tx);
  res.json({ success: true, transaction: tx });
});

// Cập nhật giao dịch
router.put('/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = transactions.findIndex(tx => tx.id === id);
  if (index === -1) return res.status(404).json({ success: false, message: 'Transaction not found' });

  transactions[index] = {
    ...transactions[index],
    taiKhoanId: req.body.taiKhoanId,
    hanMucId: req.body.hanMucId,
    type: req.body.loaiGd,
    amount: req.body.soTien,
    desc: req.body.moTa,
    date: req.body.ngayGiaoDich,
  };
  res.json({ success: true, transaction: transactions[index] });
});

// Xóa giao dịch
router.delete('/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = transactions.findIndex(tx => tx.id === id);
  if (index === -1) return res.status(404).json({ success: false, message: 'Transaction not found' });
  transactions.splice(index, 1);
  res.json({ success: true });
});

module.exports = router;
