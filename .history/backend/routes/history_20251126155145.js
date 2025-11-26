const express = require('express');
const router = express.Router();
const pool = require('../db');

// Lấy tất cả giao dịch của user
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM giao_dich WHERE user_id = ? ORDER BY ngay DESC',
      [userId]
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error("Lỗi GET history:", err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
});
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
      return res.status(404).json({ success: false, message: "Không tìm thấy giao dịch" });
    }
    const deletedTransaction = rows[0];

    // 2️⃣ Lấy tài khoản liên quan
    const bankId = deletedTransaction.tai_khoan_id;
    if (!bankId) {
      await conn.rollback();
      return res.status(400).json({ success: false, message: "Giao dịch không có tài khoản liên quan" });
    }

    const [bankRows] = await conn.execute('SELECT * FROM tai_khoan WHERE id = ?', [bankId]);
    if (bankRows.length === 0) {
      await conn.rollback();
      return res.status(404).json({ success: false, message: "Không tìm thấy tài khoản" });
    }

    let newBalance = bankRows[0].so_du;
    const amount = parseFloat(deletedTransaction.so_tien || 0);

    // 3️⃣ Hoàn tiền
    if (deletedTransaction.loai_gd === "Thu") {
      newBalance -= amount;
    } else {
      newBalance += amount;
    }
    await conn.execute('UPDATE tai_khoan SET so_du=? WHERE id=?', [newBalance, bankId]);

    // 4️⃣ Xóa giao dịch
    await conn.execute('DELETE FROM giao_dich WHERE id = ?', [id]);

    await conn.commit();

    res.json({
      success: true,
      message: "Xóa giao dịch và hoàn tiền thành công",
      deletedTransaction,
      newBalance
    });
  } catch (err) {
    await conn.rollback();
    console.error("Lỗi DELETE:", err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  } finally {
    conn.release();
  }
});


// Cập nhật giao dịch
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { so_tien } = req.body;

  if (so_tien == null) {
    return res.json({ success: false, message: "Thiếu dữ liệu" });
  }

  try {
    const [result] = await pool.execute(
      'UPDATE giao_dich SET so_tien = ? WHERE id = ?',
      [so_tien, id]
    );

    if (result.affectedRows === 0) {
      return res.json({ success: false, message: "Không tìm thấy giao dịch" });
    }

    res.json({ success: true, message: "Cập nhật thành công" });
  } catch (err) {
    console.error("Lỗi UPDATE:", err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
});

module.exports = router;
