const express = require('express');
const router = express.Router();
const pool = require('../db'); // Kết nối MySQL

router.get('/', async (req, res) => {
  const { userId } = req.query;
  if (!userId) {
    return res.status(400).json({ message: "Thiếu userId" });
  }

  try {
    // Lấy tất cả giao dịch của user
    const [transactions] = await pool.execute(
      'SELECT loai_gd, han_muc_id, so_tien, ngay_giao_dich FROM giao_dich WHERE tai_khoan_id = ?',
      [userId]
    );

    // Map categoryId -> tên category
    const categories = {
      1: "Ăn uống",
      2: "Di chuyển",
      3: "Hóa đơn",
      4: "Mua sắm",
      5: "Giải trí",
      6: "Khác",
    };

    const daily = {};
    const weekly = {};
    const monthly = {};

    const today = new Date();
    const dayStart = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    const weekStart = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay());
    const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);

    transactions.forEach(tx => {
      const catName = categories[tx.han_muc_id] || "Khác";
      const txDate = new Date(tx.ngay_giao_dich);

      // Daily
      if (txDate >= dayStart) {
        daily[catName] = (daily[catName] || 0) + tx.so_tien;
      }
      // Weekly
      if (txDate >= weekStart) {
        weekly[catName] = (weekly[catName] || 0) + tx.so_tien;
      }
      // Monthly
      if (txDate >= monthStart) {
        monthly[catName] = (monthly[catName] || 0) + tx.so_tien;
      }
    });

    res.json({ daily, weekly, monthly });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
});

module.exports = router;
