const express = require("express");
const router = express.Router();
const pool = require("../db");

// ===============================
// Lấy thông báo theo user
// ===============================
router.get("/:userId", async (req, res) => {
  const { userId } = req.params;

  const sql = `
    SELECT * FROM thong_bao
    WHERE nguoi_dung_id = ?
    ORDER BY ngay_tao DESC
  `;

  const [rows] = await pool.execute(sql, [userId]);
  res.json(rows);
});

// ===============================
// Đánh dấu đã đọc
// ===============================
router.put("/read/:id", async (req, res) => {
  const { id } = req.params;

  const sql = `
    UPDATE thong_bao
    SET da_doc = 1
    WHERE id = ?
  `;

  await pool.execute(sql, [id]);
  res.json({ message: "Đã đánh dấu đã đọc" });
});

// ===============================
// Tạo thông báo
// ===============================
router.post("/create", async (req, res) => {
  const { userId, content, type } = req.body;

  const sql = `
    INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc)
    VALUES (?, ?, ?, 0)
  `;

  await pool.execute(sql, [userId, content, type]);
  res.json({ message: "Đã tạo thông báo" });
});

module.exports = router;
