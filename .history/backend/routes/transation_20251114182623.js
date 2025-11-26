const express = require("express");
const router = express.Router();
const sql = require("mssql");

// ⚙️ Cấu hình SQL Server
const dbConfig = {
    user: "sa",
    password: "123456",
    server: "localhost",
    database: "quanly_taichinh",
    options: { encrypt: false, trustServerCertificate: true },
};

// ===============================
// 📌 LẤY DANH SÁCH GIAO DỊCH
// ===============================
router.get("/:userId", async (req, res) => {
    const { userId } = req.params;

    try {
        let pool = await sql.connect(dbConfig);
        let result = await pool
            .request()
            .input("nguoi_dung_id", sql.Int, userId)
            .query(`
                SELECT 
                    id, nguoi_dung_id AS userId, tai_khoan_id AS accountId,
                    han_muc_id AS categoryId, loai_gd AS type,
                    so_tien AS amount, mo_ta AS [desc],
                    ngay_giao_dich AS [date],
                    ngay_tao AS createdAt
                FROM giao_dich
                WHERE nguoi_dung_id = @nguoi_dung_id
                ORDER BY id DESC
            `);

        res.json({ success: true, data: result.recordset });
    } catch (err) {
        console.log("❌ Lỗi get transactions:", err);
        res.status(500).json({ success: false, message: "Server error" });
    }
});

// ===============================
// 📌 THÊM GIAO DỊCH
// ===============================
router.post("/", async (req, res) => {
    const { nguoiDungId, taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

    try {
        let pool = await sql.connect(dbConfig);
        await pool.request()
            .input("nguoi_dung_id", sql.Int, nguoiDungId)
            .input("tai_khoan_id", sql.Int, taiKhoanId)
            .input("han_muc_id", sql.Int, hanMucId)
            .input("loai_gd", sql.NVarChar, loaiGd)
            .input("so_tien", sql.Decimal(18, 2), soTien)
            .input("mo_ta", sql.NVarChar, moTa || null)
            .input("ngay_giao_dich", sql.Date, ngayGiaoDich)
            .query(`
                INSERT INTO giao_dich (nguoi_dung_id, tai_khoan_id, han_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich)
                VALUES (@nguoi_dung_id, @tai_khoan_id, @han_muc_id, @loai_gd, @so_tien, @mo_ta, @ngay_giao_dich)
            `);

        res.json({ success: true });
    } catch (err) {
        console.log("❌ Lỗi thêm:", err);
        res.status(500).json({ success: false });
    }
});

// ===============================
// 📌 SỬA GIAO DỊCH
// ===============================
router.put("/:id", async (req, res) => {
    const { id } = req.params;
    const { taiKhoanId, hanMucId, loaiGd, soTien, moTa, ngayGiaoDich } = req.body;

    try {
        let pool = await sql.connect(dbConfig);
        await pool.request()
            .input("id", sql.Int, id)
            .input("tai_khoan_id", sql.Int, taiKhoanId)
            .input("han_muc_id", sql.Int, hanMucId)
            .input("loai_gd", sql.NVarChar, loaiGd)
            .input("so_tien", sql.Decimal(18,2), soTien)
            .input("mo_ta", sql.NVarChar, moTa || null)
            .input("ngay_giao_dich", sql.Date, ngayGiaoDich)
            .query(`
                UPDATE giao_dich
                SET tai_khoan_id=@tai_khoan_id, han_muc_id=@han_muc_id,
                    loai_gd=@loai_gd, so_tien=@so_tien, mo_ta=@mo_ta,
                    ngay_giao_dich=@ngay_giao_dich
                WHERE id=@id
            `);

        res.json({ success: true });
    } catch (err) {
        console.log("❌ Lỗi sửa:", err);
        res.status(500).json({ success: false });
    }
});

// ===============================
// 📌 XÓA GIAO DỊCH
// ===============================
router.delete("/:id", async (req, res) => {
    const { id } = req.params;

    try {
        let pool = await sql.connect(dbConfig);
        await pool.request()
            .input("id", sql.Int, id)
            .query(`DELETE FROM giao_dich WHERE id=@id`);

        res.json({ success: true });
    } catch (err) {
        console.log("❌ Lỗi xóa:", err);
        res.status(500).json({ success: false });
    }
});

module.exports = router;
