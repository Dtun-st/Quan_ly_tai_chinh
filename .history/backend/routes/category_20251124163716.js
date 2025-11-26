// const express = require('express');
// const router = express.Router();
// const pool = require('../db');


// // ===============================
// // 1. GET danh mục theo user + type
// // ===============================
// router.get('/', async (req, res) => {
//   try {
//     const { userId, type } = req.query;

//     if (!userId || !type) {
//       return res.status(400).json({ message: "Thiếu userId hoặc type" });
//     }

//     // Lấy danh mục cha
//     const [parents] = await pool.execute(
//       "SELECT id, ten_danh_muc AS name, icon FROM danh_muc WHERE nguoi_dung_id = ? AND loai = ? AND parent_id IS NULL",
//       [userId, type]
//     );

//     // Lấy danh mục con
//     const [children] = await pool.execute(
//       "SELECT id, ten_danh_muc AS name, icon, parent_id FROM danh_muc WHERE nguoi_dung_id = ? AND loai = ? AND parent_id IS NOT NULL",
//       [userId, type]
//     );

//     // Gộp parent -> children
//     const result = parents.map(p => ({
//       id: p.id,
//       name: p.name,
//       icon: p.icon,
//       children: children
//         .filter(c => c.parent_id === p.id)
//         .map(c => ({
//           id: c.id,
//           name: c.name,
//           icon: c.icon,
//         }))
//     }));

//     res.json(result);

//   } catch (err) {
//     console.error("❌ Lỗi GET /categories:", err);
//     res.status(500).json({ message: "Lỗi server" });
//   }
// });


// // ===============================
// // 2. THÊM danh mục cha
// // ===============================
// router.post('/', async (req, res) => {
//   try {
//     const { name, type, icon, userId } = req.body;

//     if (!name || !type || !userId) {
//       return res.status(400).json({ message: "Thiếu dữ liệu" });
//     }

//     const [result] = await pool.execute(
//       "INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, NULL)",
//       [name, type, icon, userId]
//     );

//     res.json({
//       success: true,
//       id: result.insertId
//     });

//   } catch (err) {
//     console.error("❌ Lỗi POST /categories:", err);
//     res.status(500).json({ message: "Lỗi server" });
//   }
// });


// // ===============================
// // 3. THÊM danh mục con
// // ===============================
// router.post('/:parentId/children', async (req, res) => {
//   try {
//     const { parentId } = req.params;
//     const { name, icon, userId } = req.body;

//     if (!name || !parentId || !userId) {
//       return res.status(400).json({ message: "Thiếu dữ liệu" });
//     }

//     const [result] = await pool.execute(
//       "INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)",
//       [name, "Chi", icon, userId, parentId]
//     );

//     res.json({
//       success: true,
//       id: result.insertId
//     });

//   } catch (err) {
//     console.error("❌ Lỗi POST /categories/:parentId/children:", err);
//     res.status(500).json({ message: "Lỗi server" });
//   }
// });


// // ===============================
// // 4. SỬA danh mục
// // ===============================
// router.put('/:id', async (req, res) => {
//   try {
//     const { id } = req.params;
//     const { name, icon } = req.body;

//     await pool.execute(
//       "UPDATE danh_muc SET ten_danh_muc=?, icon=? WHERE id=?",
//       [name, icon, id]
//     );

//     res.json({ success: true });

//   } catch (err) {
//     console.error("❌ Lỗi PUT /categories/:id:", err);
//     res.status(500).json({ message: "Lỗi server" });
//   }
// });


// // ===============================
// // 5. XÓA danh mục
// // ===============================
// router.delete('/:id', async (req, res) => {
//   try {
//     const { id } = req.params;

//     // Xóa danh mục con trước
//     await pool.execute("DELETE FROM danh_muc WHERE parent_id=?", [id]);

//     // Xóa danh mục cha
//     await pool.execute("DELETE FROM danh_muc WHERE id=?", [id]);

//     res.json({ success: true });

//   } catch (err) {
//     console.error("❌ Lỗi DELETE /categories/:id:", err);
//     res.status(500).json({ message: "Lỗi server" });
//   }
// });

// module.exports = router;
const express = require("express");
const router = express.Router();
const db = require("../db"); // MySQL connection

// ===============================
// 📌 Lấy danh mục theo userId + loại (Chi/Thu)
// ===============================
router.get("/:userId", (req, res) => {
  const userId = req.params.userId;
  const type = req.query.type; // Chi hoặc Thu

  let sql = "SELECT * FROM danh_muc WHERE nguoi_dung_id = ?";
  let params = [userId];

  if (type) {
    sql += " AND loai = ?";
    params.push(type);
  }

  db.query(sql, params, (err, results) => {
    if (err) return res.status(500).json({ error: "Database error", details: err });
    return res.json(results);
  });
});

// ===============================
// 📌 Thêm danh mục
// ===============================
router.post("/", (req, res) => {
  const { ten, loai, nguoi_dung_id, parent_id = null, icon = "category" } = req.body;

  if (!ten || !loai || !nguoi_dung_id) {
    return res.status(400).json({ error: "Thiếu dữ liệu gửi lên" });
  }

  const sql = "INSERT INTO danh_muc (ten, loai, nguoi_dung_id, parent_id, icon) VALUES (?, ?, ?, ?, ?)";
  db.query(sql, [ten, loai, nguoi_dung_id, parent_id, icon], (err, result) => {
    if (err) return res.status(500).json({ error: "Lỗi thêm dữ liệu", details: err });
    return res.json({ message: "Thêm danh mục thành công", id: result.insertId });
  });
});

// ===============================
// 📌 Sửa danh mục
// ===============================
router.put("/:id", (req, res) => {
  const id = req.params.id;
  const { ten, icon } = req.body;

  if (!ten || !icon) return res.status(400).json({ error: "Thiếu dữ liệu sửa" });

  const sql = "UPDATE danh_muc SET ten = ?, icon = ? WHERE id = ?";
  db.query(sql, [ten, icon, id], (err) => {
    if (err) return res.status(500).json({ error: "Không thể sửa danh mục", details: err });
    return res.json({ message: "Sửa danh mục thành công" });
  });
});

// ===============================
// 📌 Xóa danh mục
// ===============================
router.delete("/:id", (req, res) => {
  const id = req.params.id;
  const sql = "DELETE FROM danh_muc WHERE id = ?";
  db.query(sql, [id], (err) => {
    if (err) return res.status(500).json({ error: "Không thể xoá danh mục", details: err });
    return res.json({ message: "Xoá thành công" });
  });
});

module.exports = router;
