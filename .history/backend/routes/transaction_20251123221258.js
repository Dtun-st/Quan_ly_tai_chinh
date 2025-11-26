// // const express = require("express");
// // const router = express.Router();
// // const db = require("../db.js");
// // const multer = require("multer");
// // const path = require("path");

// // // Cấu hình lưu file ảnh
// // const storage = multer.diskStorage({
// //   destination: function (req, file, cb) {
// //     cb(null, "uploads/");
// //   },
// //   filename: function (req, file, cb) {
// //     cb(null, Date.now() + path.extname(file.originalname));
// //   },
// // });
// // const upload = multer({ storage });
// // // Lấy danh sách giao dịch
// // router.get("/", async (req, res) => {
// //   try {
// //     const { userId } = req.query;
// //     const [rows] = await db.execute(
// //       "SELECT * FROM giao_dich WHERE nguoi_dung_id=?",
// //       [userId]
// //     );
// //     res.json(rows);
// //   } catch (err) {
// //     console.error(err);
// //     res.status(500).json({ error: "Internal server error" });
// //   }
// // });

// // // Thêm giao dịch
// // router.post("/", upload.single("anh_hoa_don"), async (req, res) => {
// //   try {
// //     const {
// //       userId, // nhận từ frontend
// //       tai_khoan_id,
// //       danh_muc_id,
// //       loai_gd,
// //       so_tien,
// //       mo_ta,
// //       ngay_giao_dich,
// //     } = req.body;

// //     const anh_hoa_don = req.file ? req.file.filename : null;

// //     if (!userId) {
// //       return res.status(400).json({ error: "userId is required" });
// //     }

// //     await db.execute(
// //       `INSERT INTO giao_dich(
// //         nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don
// //       ) VALUES(?,?,?,?,?,?,?,?)`,
// //       [userId, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don]
// //     );

// //     res.json({ success: true });
// //   } catch (err) {
// //     console.error(err);
// //     res.status(500).json({ error: "Internal server error" });
// //   }
// // });


// // // ===== THÊM GIAO DỊCH =====
// // router.post("/", upload.single("anh_hoa_don"), async (req, res) => {
// //   try {
// //     const {
// //       nguoi_dung_id,
// //       tai_khoan_id,
// //       danh_muc_id,
// //       loai_gd,
// //       so_tien,
// //       mo_ta,
// //       ngay_giao_dich,
// //     } = req.body;

// //     const anh_hoa_don = req.file ? req.file.filename : null;

// //     if (!nguoi_dung_id) {
// //       return res.status(400).json({ error: "nguoi_dung_id is required" });
// //     }

// //     await db.execute(
// //       `INSERT INTO giao_dich(
// //         nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don
// //       ) VALUES(?,?,?,?,?,?,?,?)`,
// //       [nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don]
// //     );

// //     res.json({ success: true });
// //   } catch (err) {
// //     console.error(err);
// //     res.status(500).json({ error: "Internal server error" });
// //   }
// // });

// // // ===== CẬP NHẬT GIAO DỊCH =====
// // router.put("/:id", upload.single("anh_hoa_don"), async (req, res) => {
// //   try {
// //     const { id } = req.params;
// //     const { tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich } = req.body;
// //     const anh_hoa_don = req.file ? req.file.filename : null;

// //     let query = "UPDATE giao_dich SET tai_khoan_id=?, danh_muc_id=?, loai_gd=?, so_tien=?, mo_ta=?, ngay_giao_dich=?";
// //     let params = [tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich];

// //     if (anh_hoa_don) {
// //       query += ", anh_hoa_don=?";
// //       params.push(anh_hoa_don);
// //     }

// //     query += " WHERE id=?";
// //     params.push(id);

// //     await db.execute(query, params);
// //     res.json({ success: true });
// //   } catch (err) {
// //     console.error(err);
// //     res.status(500).json({ error: "Internal server error" });
// //   }
// // });

// // // ===== XÓA GIAO DỊCH =====
// // router.delete("/:id", async (req, res) => {
// //   try {
// //     const { id } = req.params;
// //     await db.execute("DELETE FROM giao_dich WHERE id=?", [id]);
// //     res.json({ success: true });
// //   } catch (err) {
// //     console.error(err);
// //     res.status(500).json({ error: "Internal server error" });
// //   }
// // });
// // print("Gửi giao dịch: $taiKhoanId - $danhMucId - $nguoiDungId");

// // module.exports = router;
// const express = require("express");
// const router = express.Router();
// const db = require("../db.js");
// const multer = require("multer");
// const path = require("path");

// // ===========================
// // CẤU HÌNH LƯU ẢNH
// // ===========================
// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, "uploads/");
//   },
//   filename: function (req, file, cb) {
//     cb(null, Date.now() + path.extname(file.originalname));
//   },
// });

// const upload = multer({ storage });

// // ===========================
// // LẤY DANH SÁCH GIAO DỊCH
// // ===========================
// router.get("/", async (req, res) => {
//   try {
//     const { userId } = req.query;
//     if (!userId) {
//       return res.status(400).json({ error: "userId is required" });
//     }

//     const [rows] = await db.execute(
//       "SELECT * FROM giao_dich WHERE nguoi_dung_id=?",
//       [userId]
//     );

//     res.json(rows);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: "Internal server error" });
//   }
// });

// // ===========================
// // THÊM GIAO DỊCH
// // ===========================
// router.post("/", upload.single("anh_hoa_don"), async (req, res) => {
//   try {
//     const {
//       nguoi_dung_id,
//       tai_khoan_id,
//       danh_muc_id,
//       loai_gd,
//       so_tien,
//       mo_ta,
//       ngay_giao_dich,
//     } = req.body;

//     if (!nguoi_dung_id || !tai_khoan_id) {
//       return res.status(400).json({ error: "nguoi_dung_id và tai_khoan_id là bắt buộc" });
//     }

//     // Ép các giá trị có thể undefined thành null
//     const danhMucId = danh_muc_id || null;
//     const loaiGD = loai_gd || null;
//     const soTien = so_tien || null;
//     const moTa = mo_ta || null;
//     const ngayGD = ngay_giao_dich || null;
//     const anhHoaDon = req.file ? req.file.filename : null;

//     // Kiểm tra tài khoản có thuộc user không
//     const [tk] = await db.execute(
//       "SELECT id FROM tai_khoan WHERE id = ? AND nguoi_dung_id = ?",
//       [tai_khoan_id, nguoi_dung_id]
//     );

//     if (tk.length === 0) {
//       return res.status(400).json({ message: "Tài khoản không tồn tại hoặc không thuộc user này" });
//     }

//     // Thêm giao dịch
//     await db.execute(
//       `INSERT INTO giao_dich(
//         nguoi_dung_id, tai_khoan_id, danh_muc_id, loai_gd, so_tien, mo_ta, ngay_giao_dich, anh_hoa_don
//       ) VALUES(?,?,?,?,?,?,?,?)`,
//       [nguoi_dung_id, tai_khoan_id, danhMucId, loaiGD, soTien, moTa, ngayGD, anhHoaDon]
//     );

//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: "Internal server error" });
//   }
// });

// // ===========================
// // CẬP NHẬT GIAO DỊCH
// // ===========================
// router.put("/:id", upload.single("anh_hoa_don"), async (req, res) => {
//   try {
//     const { id } = req.params;
//     const {
//       tai_khoan_id,
//       danh_muc_id,
//       loai_gd,
//       so_tien,
//       mo_ta,
//       ngay_giao_dich,
//     } = req.body;

//     // Ép giá trị có thể undefined thành null
//     const danhMucId = danh_muc_id || null;
//     const loaiGD = loai_gd || null;
//     const soTien = so_tien || null;
//     const moTa = mo_ta || null;
//     const ngayGD = ngay_giao_dich || null;
//     const anhHoaDon = req.file ? req.file.filename : null;

//     // Build câu query động
//     let query = `UPDATE giao_dich 
//                  SET tai_khoan_id=?, danh_muc_id=?, loai_gd=?, so_tien=?, mo_ta=?, ngay_giao_dich=?`;
//     let params = [tai_khoan_id, danhMucId, loaiGD, soTien, moTa, ngayGD];

//     if (anhHoaDon) {
//       query += ", anh_hoa_don=?";
//       params.push(anhHoaDon);
//     }

//     query += " WHERE id=?";
//     params.push(id);

//     await db.execute(query, params);

//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: "Internal server error" });
//   }
// });

// // ===========================
// // XÓA GIAO DỊCH
// // ===========================
// router.delete("/:id", async (req, res) => {
//   try {
//     const { id } = req.params;
//     await db.execute("DELETE FROM giao_dich WHERE id=?", [id]);
//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: "Internal server error" });
//   }
// });

// module.exports = router;
const express = require("express");
const router = express.Router();
const db = require("../db.js");
const multer = require("multer");

// 🟧 Lấy danh sách tài khoản theo userId
router.get("/:userId", (req, res) => {
    const userId = req.params.userId;

    const query = `
        SELECT id, ten_tai_khoan, loai, so_du 
        FROM tai_khoan
        WHERE nguoi_dung_id = ?
    `;

    db.query(query, [userId], (err, result) => {
        if (err) return res.status(500).json({ error: err });
        res.json(result);
    });
});

module.exports = router;