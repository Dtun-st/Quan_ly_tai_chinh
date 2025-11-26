const express = require('express');
const router = express.Router();
const pool = require('../db');

// XÓA giao dịch
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [result] = await pool.execute(
      'DELETE FROM giao_dich WHERE id = ?',
      [id]
    );

    if (result.affectedRows === 0) {
      return res.json({ success: false, message: "Không tìm thấy giao dịch" });
    }

    res.json({ success: true, message: "Xóa thành công" });
  } catch (err) {
    console.error("Lỗi DELETE:", err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
});

// UPDATE (SỬA SỐ TIỀN)
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { so_tien } = req.body;

  if (!so_tien) {
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
