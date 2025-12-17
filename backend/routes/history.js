// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// // =====================
// // Lấy tất cả giao dịch của user
// // =====================
// router.get('/:userId', async (req, res) => {
//   const { userId } = req.params;
//   try {
//     const [rows] = await pool.execute(
//       'SELECT * FROM giao_dich WHERE nguoi_dung_id = ? ORDER BY ngay_giao_dich DESC',
//       [userId]
//     );
//     res.json({ success: true, data: rows });
//   } catch (err) {
//     console.error("Lỗi GET history:", err);
//     res.status(500).json({ success: false, message: "Lỗi server" });
//   }
// });

// // =====================
// // Xóa giao dịch và hoàn tiền về tài khoản
// // =====================
// router.delete('/:id', async (req, res) => {
//   const id = parseInt(req.params.id);
//   if (isNaN(id)) {
//     return res.status(400).json({ success: false, message: "ID giao dịch không hợp lệ" });
//   }

//   const conn = await pool.getConnection();
//   try {
//     await conn.beginTransaction();

//     // 1️⃣ Lấy giao dịch
//     const [rows] = await conn.execute('SELECT * FROM giao_dich WHERE id = ?', [id]);
//     if (rows.length === 0) {
//       await conn.rollback();
//       return res.status(404).json({ success: false, message: "Không tìm thấy giao dịch" });
//     }
//     const deletedTransaction = rows[0];

//     // 2️⃣ Lấy tài khoản liên quan
//     const bankId = deletedTransaction.tai_khoan_id;
//     if (!bankId) {
//       await conn.rollback();
//       return res.status(400).json({ success: false, message: "Giao dịch không có tài khoản liên quan" });
//     }

//     const [bankRows] = await conn.execute('SELECT * FROM tai_khoan WHERE id = ?', [bankId]);
//     if (bankRows.length === 0) {
//       await conn.rollback();
//       return res.status(404).json({ success: false, message: "Không tìm thấy tài khoản" });
//     }

//     // 3️⃣ Hoàn tiền
//     let newBalance = parseFloat(bankRows[0].so_du) || 0;
//     const amount = parseFloat(deletedTransaction.so_tien) || 0;

//     if (deletedTransaction.loai_gd === "Thu") {
//       newBalance -= amount;
//     } else {
//       newBalance += amount;
//     }

//     // Cắt còn 2 chữ số thập phân
//     newBalance = parseFloat(newBalance.toFixed(2));

//     await conn.execute('UPDATE tai_khoan SET so_du = ? WHERE id = ?', [newBalance, bankId]);

//     // 4️⃣ Xóa giao dịch
//     await conn.execute('DELETE FROM giao_dich WHERE id = ?', [id]);

//     await conn.commit();

//     console.log("Giao dịch bị xóa:", deletedTransaction);
//     console.log("Số dư mới:", newBalance);

//     res.json({
//       success: true,
//       message: "Xóa giao dịch và hoàn tiền thành công",
//       deletedTransaction,
//       newBalance
//     });

//   } catch (err) {
//     await conn.rollback();
//     console.error("Lỗi DELETE:", err);
//     res.status(500).json({ success: false, message: "Lỗi server" });
//   } finally {
//     conn.release();
//   }
// });

// // =====================
// // Cập nhật giao dịch
// // =====================
// router.put('/:id', async (req, res) => {
//   const { id } = req.params;
//   const { so_tien } = req.body;

//   if (so_tien == null) {
//     return res.status(400).json({ success: false, message: "Thiếu dữ liệu" });
//   }

//   try {
//     const [result] = await pool.execute(
//       'UPDATE giao_dich SET so_tien = ? WHERE id = ?',
//       [so_tien, id]
//     );

//     if (result.affectedRows === 0) {
//       return res.status(404).json({ success: false, message: "Không tìm thấy giao dịch" });
//     }

//     res.json({ success: true, message: "Cập nhật thành công" });
//   } catch (err) {
//     console.error("Lỗi UPDATE:", err);
//     res.status(500).json({ success: false, message: "Lỗi server" });
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const pool = require('../db');

// =====================
// Lấy tất cả giao dịch của user
// =====================
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM giao_dich WHERE nguoi_dung_id = ? ORDER BY ngay_giao_dich DESC',
      [userId]
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error("❌ Lỗi GET giao dịch:", err);
    res.status(500).json({ success: false, message: "Có lỗi xảy ra khi lấy danh sách giao dịch" });
  }
});

// =====================
// Xóa giao dịch và hoàn tiền về tài khoản
// =====================
router.delete('/:id', async (req, res) => {
  const id = parseInt(req.params.id);
  if (isNaN(id)) {
    return res.status(400).json({ success: false, message: "ID giao dịch không hợp lệ" });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // 1️⃣ Lấy giao dịch
    const [rows] = await conn.execute('SELECT * FROM giao_dich WHERE id = ?', [id]);
    if (rows.length === 0) {
      await conn.rollback();
      return res.status(404).json({ success: false, message: "Giao dịch không tồn tại" });
    }
    const deletedTransaction = rows[0];

    // 2️⃣ Lấy tài khoản liên quan
    const bankId = deletedTransaction.tai_khoan_id;
    if (!bankId) {
      await conn.rollback();
      return res.status(400).json({ success: false, message: "Giao dịch không liên kết với tài khoản nào" });
    }

    const [bankRows] = await conn.execute('SELECT * FROM tai_khoan WHERE id = ?', [bankId]);
    if (bankRows.length === 0) {
      await conn.rollback();
      return res.status(404).json({ success: false, message: "Tài khoản liên quan không tồn tại" });
    }

    // 3️⃣ Hoàn tiền
    let newBalance = parseFloat(bankRows[0].so_du) || 0;
    const amount = parseFloat(deletedTransaction.so_tien) || 0;

    if (deletedTransaction.loai_gd === "Thu") {
      newBalance -= amount;
    } else {
      newBalance += amount;
    }

    newBalance = parseFloat(newBalance.toFixed(2));

    await conn.execute('UPDATE tai_khoan SET so_du = ? WHERE id = ?', [newBalance, bankId]);

    // 4️⃣ Xóa giao dịch
    await conn.execute('DELETE FROM giao_dich WHERE id = ?', [id]);

    await conn.commit();

    res.json({
      success: true,
      message: "Giao dịch đã được xóa và số dư tài khoản đã được cập nhật",
      deletedTransaction,
      newBalance
    });

  } catch (err) {
    await conn.rollback();
    console.error("❌ Lỗi DELETE giao dịch:", err);
    res.status(500).json({ success: false, message: "Có lỗi xảy ra khi xóa giao dịch" });
  } finally {
    conn.release();
  }
});

// =====================
// Cập nhật giao dịch
// =====================
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { so_tien } = req.body;

  if (so_tien == null) {
    return res.status(400).json({ success: false, message: "Vui lòng cung cấp số tiền để cập nhật" });
  }

  try {
    const [result] = await pool.execute(
      'UPDATE giao_dich SET so_tien = ? WHERE id = ?',
      [so_tien, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: "Giao dịch không tồn tại" });
    }

    res.json({ success: true, message: "Giao dịch đã được cập nhật thành công" });
  } catch (err) {
    console.error("❌ Lỗi UPDATE giao dịch:", err);
    res.status(500).json({ success: false, message: "Có lỗi xảy ra khi cập nhật giao dịch" });
  }
});

module.exports = router;
