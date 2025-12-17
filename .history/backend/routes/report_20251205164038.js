// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// // A. Default: daily, weekly, monthly
// router.get('/', async (req, res) => {
//   const userId = req.query.userId;
//   if (!userId) return res.status(400).json({success:false,message:'Thiếu userId'});

//   try {
//     const [transactions] = await pool.execute(
//       'SELECT so_tien, loai_gd, ngay_giao_dich FROM giao_dich WHERE nguoi_dung_id = ?',
//       [userId]
//     );

//     const now = new Date();
//     const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
//     const startOfWeek = new Date(now);
//     startOfWeek.setDate(now.getDate() - now.getDay());
//     const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

//     const daily = {};
//     const weekly = {};
//     const monthly = {};

//     transactions.forEach(tx => {
//       const date = new Date(tx.ngay_giao_dich);
//       const type = tx.loai_gd || 'Khác';
//       const amount = Number(tx.so_tien) || 0;

//       if (date >= startOfMonth) monthly[type] = (monthly[type] || 0) + amount;
//       if (date >= startOfWeek) weekly[type] = (weekly[type] || 0) + amount;
//       if (date >= startOfDay) daily[type] = (daily[type] || 0) + amount;
//     });

//     res.json({success:true, daily, weekly, monthly});
//   } catch(err) {
//     console.error(err);
//     res.status(500).json({success:false,message:'Lỗi server'});
//   }
// });

// // B. Month filter
// router.get('/month', async (req,res)=>{
//   const {userId, month, year} = req.query;
//   if (!userId || !month || !year) return res.status(400).json({success:false,message:'Thiếu tham số'});

//   try {
//     const start = new Date(year, month-1, 1);
//     const end = new Date(year, month, 1);

//     const [data] = await pool.execute(
//       `SELECT so_tien, loai_gd 
//        FROM giao_dich 
//        WHERE nguoi_dung_id = ? AND ngay_giao_dich >= ? AND ngay_giao_dich < ?`,
//       [userId, start, end]
//     );

//     const monthData = {};
//     data.forEach(tx=>{
//       const category = tx.loai_gd || 'Khác';
//       const amount = Number(tx.so_tien) || 0;
//       monthData[category] = (monthData[category]||0)+amount;
//     });

//     res.json({success:true, monthData});
//   } catch(err){
//     console.error(err);
//     res.status(500).json({success:false,message:'Lỗi server'});
//   }
// });

// // C. Range filter
// router.get('/range', async (req,res)=>{
//   const {userId, start, end} = req.query;
//   if (!userId || !start || !end) return res.status(400).json({success:false,message:'Thiếu tham số'});

//   try {
//     const [data] = await pool.execute(
//       `SELECT so_tien, loai_gd, ngay_giao_dich 
//        FROM giao_dich 
//        WHERE nguoi_dung_id = ? AND ngay_giao_dich BETWEEN ? AND ?`,
//       [userId, start, end]
//     );

//     const rangeData = {};
//     data.forEach(tx=>{
//       const d = new Date(tx.ngay_giao_dich);
//       const label = `${d.getMonth()+1}/${d.getFullYear()}`;
//       rangeData[label] = (rangeData[label]||0)+Number(tx.so_tien);
//     });

//     res.json({success:true, rangeData});
//   } catch(err){
//     console.error(err);
//     res.status(500).json({success:false,message:'Lỗi server'});
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const pool = require('../db');

// A. Default daily, weekly, monthly
router.get('/', async (req, res) => {
  const userId = req.query.userId;
  if (!userId) return res.status(400).json({success:false,message:'Thiếu userId'});

  try {
    const [transactions] = await pool.execute(
      `SELECT so_tien, loai_gd, danh_muc, ngay_giao_dich 
       FROM giao_dich 
       WHERE nguoi_dung_id = ?`,
      [userId]
    );

    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - now.getDay());
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const daily = { thu:{}, chi:{} };
    const weekly = { thu:{}, chi:{} };
    const monthly = { thu:{}, chi:{} };

    const pushData = (container, type, cate, amt) => {
      container[type][cate] = (container[type][cate] || 0) + amt;
    };

    transactions.forEach(tx => {
      const date = new Date(tx.ngay_giao_dich);
      const type = tx.loai_gd === 'thu' ? 'thu' : 'chi';
      const cate = tx.danh_muc || "Khác";
      const amt = Number(tx.so_tien) || 0;

      if (date >= startOfMonth) pushData(monthly, type, cate, amt);
      if (date >= startOfWeek) pushData(weekly, type, cate, amt);
      if (date >= startOfDay) pushData(daily, type, cate, amt);
    });

    res.json({success:true, daily, weekly, monthly});
  } catch(err) {
    console.error(err);
    res.status(500).json({success:false,message:'Lỗi server'});
  }
});

// B. Monthly filter
router.get('/month', async (req,res)=>{
  const {userId, month, year} = req.query;

  if (!userId || !month || !year)
    return res.status(400).json({success:false,message:'Thiếu tham số'});

  try {
    const start = new Date(year, month-1, 1);
    const end = new Date(year, month, 1);

    const [rows] = await pool.execute(
      `SELECT so_tien, loai_gd, danh_muc 
       FROM giao_dich 
       WHERE nguoi_dung_id = ? AND ngay_giao_dich >= ? AND ngay_giao_dich < ?`,
      [userId, start, end]
    );

    const monthData = { thu:{}, chi:{} };

    rows.forEach(tx => {
      const type = tx.loai_gd === 'thu' ? 'thu' : 'chi';
      const cate = tx.danh_muc || "Khác";
      const amt = Number(tx.so_tien) || 0;
      monthData[type][cate] = (monthData[type][cate] || 0) + amt;
    });

    res.json({success:true, monthData});
  } catch(err){
    console.error(err);
    res.status(500).json({success:false,message:'Lỗi server'});
  }
});

module.exports = router;
