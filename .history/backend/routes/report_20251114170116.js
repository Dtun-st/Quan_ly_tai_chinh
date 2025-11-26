// E:\financial_app\backend\routes\report.js
const express = require('express');
const router = express.Router();
const pool = require('../db'); // kết nối MySQL

router.get('/', async (req, res) => {
  const userId = req.query.userId;
  if (!userId) {
    return res.status(400).json({ success: false, message: 'Thiếu userId' });
  }

  try {
    const [transactions] = await pool.execute(
      'SELECT so_tien, loai_gd, ngay_giao_dich FROM transaction WHERE nguoi_dung_id = ?',
      [userId]
    );

    console.log("Transactions:", transactions); // 🔍 in ra dữ liệu lấy được

    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay());
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const daily = {};
    const weekly = {};
    const monthly = {};

    transactions.forEach(tx => {
      console.log("Processing tx:", tx); // 🔍 xem từng giao dịch
      const type = tx.loai_gd;
      const amount = Number(tx.so_tien || 0); // phòng lỗi null/undefined
      const date = new Date(tx.ngay_giao_dich);

      if (date >= startOfMonth) monthly[type] = (monthly[type] || 0) + amount;
      if (date >= startOfWeek) weekly[type] = (weekly[type] || 0) + amount;
      if (date >= startOfDay) daily[type] = (daily[type] || 0) + amount;
    });

    res.json({ success: true, report: { daily, weekly, monthly } });
  } catch (err) {
    console.error("Report error:", err); // 🔍 log lỗi chi tiết
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});


module.exports = router;
