const express = require('express');
const router = express.Router();
const pool = require('../db');

router.get('/', async (req, res) => {
  const userId = req.query.userId;

  if (!userId) {
    return res.status(400).json({ success: false, message: 'Thiếu userId' });
  }

  try {
    const [transactions] = await pool.execute(
      'SELECT so_tien, loai_gd, ngay_giao_dich FROM giao_dich WHERE nguoi_dung_id = ?',
      [userId]
    );

    console.log("UserId:", userId);
    console.log("Transactions fetched:", transactions.length);

    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay()); 
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const daily = {};
    const weekly = {};
    const monthly = {};

    transactions.forEach(tx => {
      try {
        const type = tx.loai_gd || 'Khác';
        const amount = Number(tx.so_tien) || 0;
        const date = new Date(tx.ngay_giao_dich);

        if (date >= startOfMonth) monthly[type] = (monthly[type] || 0) + amount;
        if (date >= startOfWeek) weekly[type] = (weekly[type] || 0) + amount;
        if (date >= startOfDay) daily[type] = (daily[type] || 0) + amount;
      } catch (e) {
        console.error("Error processing transaction:", tx, e);
      }
    });

    res.json({ success: true, daily, weekly, monthly });
  } catch (err) {
    console.error("Report error:", err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
