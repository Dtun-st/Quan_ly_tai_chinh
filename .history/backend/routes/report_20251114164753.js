const express = require('express');
const router = express.Router();
const pool = require('../db'); // kết nối MySQL

// Lấy báo cáo chi tiêu
router.get('/', async (req, res) => {
  const { userId, type } = req.query;

  if (!userId || !type) {
    return res.status(400).json({ message: "Thiếu userId hoặc type" });
  }

  try {
    let query = '';
    switch(type) {
      case 'daily':
        query = `
          SELECT han_muc_id, SUM(so_tien) as total
          FROM giao_dich
          WHERE tai_khoan_id = ? AND DATE(ngay_giao_dich) = CURDATE()
          GROUP BY han_muc_id`;
        break;
      case 'weekly':
        query = `
          SELECT han_muc_id, SUM(so_tien) as total
          FROM giao_dich
          WHERE tai_khoan_id = ? AND YEARWEEK(ngay_giao_dich, 1) = YEARWEEK(CURDATE(), 1)
          GROUP BY han_muc_id`;
        break;
      case 'monthly':
        query = `
          SELECT han_muc_id, SUM(so_tien) as total
          FROM giao_dich
          WHERE tai_khoan_id = ? AND MONTH(ngay_giao_dich) = MONTH(CURDATE())
          GROUP BY han_muc_id`;
        break;
      default:
        return res.status(400).json({ message: "Type không hợp lệ" });
    }

    const [rows] = await pool.execute(query, [userId]);

    // Map category ID -> tên category
    const categories = {
      1: "Ăn uống",
      2: "Di chuyển",
      3: "Hóa đơn",
      4: "Mua sắm",
      5: "Giải trí",
      6: "Khác",
    };

    const result = {};
    rows.forEach(r => {
      const name = categories[r.han_muc_id] || "Khác";
      result[name] = Number(r.total);
    });

    res.json(result);

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
});

module.exports = router;
