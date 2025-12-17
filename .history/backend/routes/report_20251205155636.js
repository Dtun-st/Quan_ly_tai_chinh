// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// router.get('/', async (req, res) => {
//   const userId = req.query.userId;

//   if (!userId) {
//     return res.status(400).json({ success: false, message: 'Thiếu userId' });
//   }

//   try {
//     const [transactions] = await pool.execute(
//       'SELECT so_tien, loai_gd, ngay_giao_dich FROM giao_dich WHERE nguoi_dung_id = ?',
//       [userId]
//     );

//     console.log("UserId:", userId);
//     console.log("Transactions fetched:", transactions.length);

//     const now = new Date();
//     const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
//     const startOfWeek = new Date(now);
//     startOfWeek.setDate(now.getDate() - now.getDay()); 
//     const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

//     const daily = {};
//     const weekly = {};
//     const monthly = {};

//     transactions.forEach(tx => {
//       try {
//         const type = tx.loai_gd || 'Khác';
//         const amount = Number(tx.so_tien) || 0;
//         const date = new Date(tx.ngay_giao_dich);

//         if (date >= startOfMonth) monthly[type] = (monthly[type] || 0) + amount;
//         if (date >= startOfWeek) weekly[type] = (weekly[type] || 0) + amount;
//         if (date >= startOfDay) daily[type] = (daily[type] || 0) + amount;
//       } catch (e) {
//         console.error("Error processing transaction:", tx, e);
//       }
//     });

//     res.json({ success: true, daily, weekly, monthly });
//   } catch (err) {
//     console.error("Report error:", err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });

// module.exports = router;
const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/report", async (req, res) => {
  const { userId } = req.query;
  const now = new Date();
  const month = now.getMonth() + 1;
  const year = now.getFullYear();

  try {
    const [data] = await pool.execute(
      `SELECT type, SUM(amount) as total
       FROM transactions
       WHERE userId = ? AND MONTH(date) = ? AND YEAR(date) = ?
       GROUP BY type`,
      [userId, month, year]
    );

    const monthly = {
      income: data.find(x => x.type === 'income')?.total || 0,
      expense: data.find(x => x.type === 'expense')?.total || 0,
    };

    res.json({ monthly });
  } catch (error) {
    res.status(500).json({ error });
  }
});

router.get("/report/month", async (req, res) => {
  const { userId, month, year } = req.query;

  try {
    const [data] = await pool.execute(
      `SELECT type, SUM(amount) as total
       FROM transactions
       WHERE userId = ? AND MONTH(date) = ? AND YEAR(date) = ?
       GROUP BY type`,
      [userId, month, year]
    );

    const monthData = {
      income: data.find(x => x.type === 'income')?.total || 0,
      expense: data.find(x => x.type === 'expense')?.total || 0,
    };

    res.json({ monthData });
  } catch (error) {
    res.status(500).json({ error });
  }
});

router.get("/report/range", async (req, res) => {
  const { userId, start, end } = req.query;

  try {
    const [data] = await pool.execute(
      `SELECT type, SUM(amount) as total
       FROM transactions
       WHERE userId = ? AND DATE(date) BETWEEN ? AND ?
       GROUP BY type`,
      [userId, start, end]
    );

    const rangeData = {
      income: data.find(x => x.type === 'income')?.total || 0,
      expense: data.find(x => x.type === 'expense')?.total || 0,
    };

    res.json({ rangeData });
  } catch (error) {
    res.status(500).json({ error });
  }
});

module.exports = router;
