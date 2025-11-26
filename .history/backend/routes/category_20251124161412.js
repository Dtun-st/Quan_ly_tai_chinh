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
const pool = require("../db");


// Tạo dữ liệu mẫu khi user mới đăng ký
async function createDefaultCategories(userId) {
  const defaultChi = [
    ["Ăn uống", "fa-utensils"],
    ["Mua sắm", "fa-shopping-bag"],
    ["Đi lại", "fa-car"],
    ["Giải trí", "fa-film"],
  ];

  const defaultThu = [
    ["Lương", "fa-money-bill-wave"],
    ["Thưởng", "fa-gift"],
    ["Kinh doanh", "fa-home"],
  ];

  for (const [name, icon] of defaultChi) {
    await pool.execute(
      "INSERT INTO danh_muc (nguoi_dung_id, ten, loai, icon, parent_id) VALUES (?, ?, 'Chi', ?, NULL)",
      [userId, name, icon]
    );
  }

  for (const [name, icon] of defaultThu) {
    await pool.execute(
      "INSERT INTO danh_muc (nguoi_dung_id, ten, loai, icon, parent_id) VALUES (?, ?, 'Thu', ?, NULL)",
      [userId, name, icon]
    );
  }
}


// GET danh mục theo userId + type
router.get("/:userId", async (req, res) => {
  const { userId } = req.params;
  const { type } = req.query;

  try {
    const [rows] = await pool.execute(
      `SELECT * FROM danh_muc WHERE nguoi_dung_id = ? AND loai = ? ORDER BY parent_id ASC`,
      [userId, type]
    );

    if (rows.length === 0) {
      await createDefaultCategories(userId);
      const [newRows] = await pool.execute(
        `SELECT * FROM danh_muc WHERE nguoi_dung_id = ? AND loai = ?`,
        [userId, type]
      );
      return res.json({ success: true, categories: formatCategories(newRows) });
    }

    res.json({ success: true, categories: formatCategories(rows) });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});


// Format cha/con
function formatCategories(rows) {
  const parents = rows.filter((r) => r.parent_id === null);
  return parents.map((p) => ({
    id: p.id,
    name: p.ten,
    icon: p.icon,
    children: rows
      .filter((c) => c.parent_id === p.id)
      .map((c) => ({
        id: c.id,
        name: c.ten,
        icon: c.icon,
      })),
  }));
}


// Thêm danh mục cha
router.post("/", async (req, res) => {
  const { userId, name, type, icon } = req.body;

  try {
    await pool.execute(
      "INSERT INTO danh_muc (nguoi_dung_id, ten, loai, icon, parent_id) VALUES (?, ?, ?, ?, NULL)",
      [userId, name, type, icon]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Thêm danh mục con
router.post("/add-child", async (req, res) => {
  const { parentId, name, icon } = req.body;

  try {
    await pool.execute(
      "INSERT INTO danh_muc (nguoi_dung_id, ten, loai, icon, parent_id) SELECT nguoi_dung_id, ?, loai, ?, ? FROM danh_muc WHERE id = ?",
      [name, icon, parentId, parentId]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Sửa danh mục
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { name, icon } = req.body;

  try {
    await pool.execute(
      "UPDATE danh_muc SET ten = ?, icon = ? WHERE id = ?",
      [name, icon, id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Xóa danh mục cha + con
router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    await pool.execute("DELETE FROM danh_muc WHERE parent_id = ?", [id]);
    await pool.execute("DELETE FROM danh_muc WHERE id = ?", [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

module.exports = router;
module.exports.insertDefaultCategories = createDefaultCategories;