const express = require("express");
const router = express.Router();
const pool = require("../db"); 

router.get("/:userId", async (req, res) => {
  const userId = req.params.userId;

  try {
    const [rows] = await pool.execute(
      `
      SELECT 
        id,
        nguoi_dung_id AS userId,
        tai_khoan_id AS accountId,
        han_muc_id AS categoryId,
        loai_gd AS type,
        so_tien AS amount,
        mo_ta AS \`desc\`,
        ngay_giao_dich AS \`date\`,
        ngay_tao AS createdAt
      FROM giao_dich
      WHERE nguoi_dung_id = ?
      ORDER BY id DESC
      `,
      [userId]
    );

    res.json({ success: true, data: rows });
  } catch (err) {
    console.error("❌ Lỗi GET transactions:", err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});


router.post("/", async (req, res) => {
  const {
    nguoiDungId,
    taiKhoanId,
    hanMucId,
    loaiGd,
    soTien,
    moTa,
    ngayGiaoDich,
  } = req.body;

  try {
    await pool.execute(
      `
      INSERT INTO giao_dich 
      (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [
        nguoiDungId,
        taiKhoanId,
        hanMucId,
        loaiGd,
        soTien,
        moTa || null,
        ngayGiaoDich,
      ]
    );

    res.json({ success: true });
  } catch (err) {
    console.error("❌ Lỗi thêm transaction:", err);
    res.status(500).json({ success: false });
  }
});


router.put("/:id", async (req, res) => {
  const id = req.params.id;
  const { taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

  try {
    await pool.execute(
      `
      UPDATE giao_dich
      SET tai_khoan_id=?, han_muc_id=?, loai_gd=?, so_tien=?, mo_ta=?, ngay_giao_dich=?
      WHERE id=?
      `,
      [
        taiKhoanId,
        hanMucId,
        loaiGd,
        soTien,
        moTa || null,
        ngayGiaoDich,
        id,
      ]
    );

    res.json({ success: true });
  } catch (err) {
    console.error("❌ Lỗi cập nhật transaction:", err);
    res.status(500).json({ success: false });
  }
});

router.delete("/:id", async (req, res) => {
  const id = req.params.id;

  try {
    await pool.execute(`DELETE FROM giao_dich WHERE id=?`, [id]);
    res.json({ success: true });
  } catch (err) {
    console.error("❌ Lỗi xóa transaction:", err);
    res.status(500).json({ success: false });
  }
});

module.exports = router;
