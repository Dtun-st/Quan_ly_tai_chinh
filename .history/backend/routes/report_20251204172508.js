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
import express from 'express';
import pool from '../config/db.js';

const router = express.Router();

// 📌 API cố định daily / weekly / monthly
router.get('/', async (req, res) => {
  const { userId, filter } = req.query;

  if (!userId || !filter) {
    return res.status(400).json({ success: false, message: 'Thiếu tham số' });
  }

  try {
    let query = '';

    if (filter === 'daily') {
      query = `SELECT loai_gd, SUM(so_tien) AS total
               FROM giao_dich
               WHERE nguoi_dung_id = ?
               AND DATE(ngay_giao_dich) = CURDATE()
               GROUP BY loai_gd`;
    }

    if (filter === 'weekly') {
      query = `SELECT loai_gd, SUM(so_tien) AS total
               FROM giao_dich
               WHERE nguoi_dung_id = ?
               AND YEARWEEK(ngay_giao_dich, 1) = YEARWEEK(CURDATE(), 1)
               GROUP BY loai_gd`;
    }

    if (filter === 'monthly') {
      query = `SELECT loai_gd, SUM(so_tien) AS total
               FROM giao_dich
               WHERE nguoi_dung_id = ?
               AND MONTH(ngay_giao_dich) = MONTH(CURDATE())
               AND YEAR(ngay_giao_dich) = YEAR(CURDATE())
               GROUP BY loai_gd`;
    }

    const [rows] = await pool.execute(query, [userId]);

    const result = {};
    rows.forEach(row => {
      result[row.loai_gd || 'Khác'] = Number(row.total) || 0;
    });

    return res.json({ success: true, data: result });
  } catch (err) {
    console.error('Lỗi báo cáo:', err);
    return res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

// 📌 API lọc theo khoảng thời gian bất kỳ
router.get('/range', async (req, res) => {
  const { userId, start, end } = req.query;

  if (!userId || !start || !end) {
    return res.status(400).json({ success: false, message: 'Thiếu tham số lọc thời gian' });
  }

  try {
    const [transactions] = await pool.execute(
      `SELECT loai_gd, SUM(so_tien) AS total
       FROM giao_dich
       WHERE nguoi_dung_id = ? AND DATE(ngay_giao_dich) BETWEEN ? AND ?
       GROUP BY loai_gd`,
      [userId, start, end]
    );

    const data = {};
    transactions.forEach(tx => {
      data[tx.loai_gd || 'Khác'] = Number(tx.total) || 0;
    });

    return res.json({ success: true, data });
  } catch (err) {
    console.error('Range report error:', err);
    return res.status(500).json({ success: false, message: 'Lỗi server' });
  }
});

export default router;
