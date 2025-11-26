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

// Xóa giao dịch
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    // Lấy thông tin giao dịch trước khi xóa
    const [rows] = await pool.execute('SELECT * FROM giao_dich WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.json({ success: false, message: "Không tìm thấy giao dịch" });
    }
    const deletedTransaction = rows[0];

    // Xóa giao dịch
    await pool.execute('DELETE FROM giao_dich WHERE id = ?', [id]);

    // Trả về giao dịch vừa xóa
    res.json({ 
      success: true, 
      message: "Xóa thành công",
      deletedTransaction
    });
  } catch (err) {
    console.error("Lỗi DELETE:", err);
    res.status(500).json({ success: false, message: "Lỗi server" });
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
