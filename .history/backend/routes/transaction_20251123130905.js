const express = require("express");
const router = express.Router();
const db = require("../db.js");
const multer = require("multer");
const path = require("path");

// Cấu hình lưu file ảnh
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
const upload = multer({ storage });

// ===== LẤY DANH SÁCH GIAO DỊCH =====
router.get("/", async (req, res) => {
  try {
    const { userId } = req.query; // userId từ frontend
    const [rows] = await db.execute(
      "SELECT * FROM giao_dich WHERE nguoi_dung_id=?",
      [userId]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ===== THÊM GIAO DỊCH =====
router.post("/", upload.single("anh_hoa_don"), async (req, res) => {
  try {
    const { userId, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich } = req.body;
    const anh_hoa_don = req.file ? req.file.filename : null;

    await db.execute(
      `INSERT INTO giao_dich(
        nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don
      ) VALUES(?,?,?,?,?,?,?,?)`,
      [userId, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don]
    );

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ===== CẬP NHẬT GIAO DỊCH =====
router.put("/:id", upload.single("anh_hoa_don"), async (req, res) => {
  try {
    const { id } = req.params;
    const { tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich } = req.body;
    const anh_hoa_don = req.file ? req.file.filename : null;

    let query = "UPDATE giao_dich SET tai_khoan_id=?, danh_muc_id=?, loai_gd=?, so_tien=?, mo_ta=?, ngay_giao_dich=?";
    let params = [tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich];

    if (anh_hoa_don) {
      query += ", anh_hoa_don=?";
      params.push(anh_hoa_don);
    }

    query += " WHERE id=?";
    params.push(id);

    await db.execute(query, params);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ===== XÓA GIAO DỊCH =====
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    await db.execute("DELETE FROM giao_dich WHERE id=?", [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
