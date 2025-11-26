const express = require('express');
const router = express.Router();
const pool = require('../db'); // connection MySQL

router.get('/', async (req, res) => {
  const userId = req.query.userId;
  if (!userId) return res.status(400).json({ success: false, message: 'Thiếu userId' });

  try {
    const [transactions] = await pool.execute(
      'SELECT so_tien, loai_gd, ngay_giao_dich FROM transaction WHERE tai_khoan_id = ?',
      [userId]
    );

    const daily = {};
    const weekly = {};
    const monthly = {};

    const now = new Date();
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay());
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    transactions.forEach(tx => {
      const type = tx.loai_gd || 'Khác';
      const date = new Date(tx.ngay_giao_dich);

      if (date.toDateString() === now.toDateString()) {
        daily[type] = (daily[type] || 0) + Number(tx.so_tien);
      }

      if (date >= startOfWeek) {
        weekly[type] = (weekly[type] || 0) + Number(tx.so_tien);
      }

      if (date >= startOfMonth) {
        monthly[type] = (monthly[type] || 0) + Number(tx.so_tien);
      }
    });

    res.json({ success: true, daily, weekly, monthly });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
