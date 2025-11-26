// E:\financial_app\backend\routes\report.js
const express = require('express');
const router = express.Router();
const pool = require('../db'); // kết nối MySQL

// Lấy báo cáo chi tiêu
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

    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay()); // Chủ nhật đầu tuần
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const daily = {};
    const weekly = {};
    const monthly = {};

    transactions.forEach(tx => {
      const type = tx.loai_gd;
      const amount = Number(tx.so_tien);
      const date = new Date(tx.ngay_giao_dich);

      // Monthly
      if (date >= startOfMonth) {
        monthly[type] = (monthly[type] || 0) + amount;
      }

      // Weekly
      if (date >= startOfWeek) {
        weekly[type] = (weekly[type] || 0) + amount;
      }

      // Daily
      if (date >= startOfDay) {
        daily[type] = (daily[type] || 0) + amount;
      }
    });

    res.json({
      success: true,
      report: {
        daily,
        weekly,
        monthly,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

module.exports = router;
