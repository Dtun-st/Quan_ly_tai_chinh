// const express = require('express');
// const router = express.Router();
// const pool = require('../db');
// // Dữ liệu mặc định
// // Dữ liệu mặc định mở rộng, icon là FontAwesome class
// const defaultCategories = [
//   // Danh mục cha
//   { name: 'Ăn uống', type: 'Chi', icon: 'fa-utensils', parentName: null },
//   { name: 'Mua sắm', type: 'Chi', icon: 'fa-shopping-bag', parentName: null },
//   { name: 'Nhà cửa', type: 'Chi', icon: 'fa-home', parentName: null },
//   { name: 'Xe cộ', type: 'Chi', icon: 'fa-car', parentName: null },
//   { name: 'Giải trí', type: 'Chi', icon: 'fa-film', parentName: null },
//   { name: 'Y tế', type: 'Chi', icon: 'fa-notes-medical', parentName: null },
//   { name: 'Học tập', type: 'Chi', icon: 'fa-book', parentName: null },
//   { name: 'Lương thưởng', type: 'Thu', icon: 'fa-money-bill-wave', parentName: null },

//   // Danh mục con
//   { name: 'Cà phê', type: 'Chi', icon: 'fa-coffee', parentName: 'Ăn uống' },
//   { name: 'Ăn sáng', type: 'Chi', icon: 'fa-bread-slice', parentName: 'Ăn uống' },
//   { name: 'Ăn trưa', type: 'Chi', icon: 'fa-hamburger', parentName: 'Ăn uống' },
//   { name: 'Ăn tối', type: 'Chi', icon: 'fa-pizza-slice', parentName: 'Ăn uống' },
//   { name: 'Nước uống', type: 'Chi', icon: 'fa-wine-glass', parentName: 'Ăn uống' },
//   { name: 'Quần áo', type: 'Chi', icon: 'fa-tshirt', parentName: 'Mua sắm' },
//   { name: 'Giày dép', type: 'Chi', icon: 'fa-shoe-prints', parentName: 'Mua sắm' },
//   { name: 'Điện thoại', type: 'Chi', icon: 'fa-mobile-alt', parentName: 'Mua sắm' },
//   { name: 'Điện nước', type: 'Chi', icon: 'fa-bolt', parentName: 'Nhà cửa' },
//   { name: 'Internet', type: 'Chi', icon: 'fa-wifi', parentName: 'Nhà cửa' },
//   { name: 'Xăng xe', type: 'Chi', icon: 'fa-gas-pump', parentName: 'Xe cộ' },
//   { name: 'Bảo dưỡng xe', type: 'Chi', icon: 'fa-tools', parentName: 'Xe cộ' },
//   { name: 'Rạp chiếu phim', type: 'Chi', icon: 'fa-film', parentName: 'Giải trí' },
//   { name: 'Du lịch', type: 'Chi', icon: 'fa-plane', parentName: 'Giải trí' },
//   { name: 'Bác sĩ', type: 'Chi', icon: 'fa-user-doctor', parentName: 'Y tế' },
//   { name: 'Thuốc men', type: 'Chi', icon: 'fa-pills', parentName: 'Y tế' },
//   { name: 'Sách', type: 'Chi', icon: 'fa-book', parentName: 'Học tập' },
//   { name: 'Văn phòng phẩm', type: 'Chi', icon: 'fa-pencil-alt', parentName: 'Học tập' },
//   { name: 'Tiền lương', type: 'Thu', icon: 'fa-money-bill-wave', parentName: 'Lương thưởng' },
//   { name: 'Thưởng', type: 'Thu', icon: 'fa-gift', parentName: 'Lương thưởng' },
// ];

// // Hàm chèn dữ liệu mặc định cho user mới
// async function insertDefaultCategories(userId) {
//   const parentMap = {};
//   for (const cat of defaultCategories) {
//     let parentId = null;
//     if (cat.parentName) parentId = parentMap[cat.parentName] || null;

//     const [result] = await pool.execute(
//       'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
//       [cat.name, cat.type, cat.icon, userId, parentId]
//     );

//     if (!cat.parentName) parentMap[cat.name] = result.insertId;
//   }
// }

// // GET danh mục theo user
// router.get('/', async (req, res) => {
//   const { userId, type } = req.query;
//   try {
//     const [parents] = await pool.query(
//       'SELECT * FROM danh_muc WHERE loai = ? AND nguoi_dung_id = ? AND (parent_id IS NULL OR parent_id = 0)',
//       [type, userId]
//     );

//     const categories = [];

//     for (let parent of parents) {
//       const [children] = await pool.query(
//         'SELECT * FROM danh_muc WHERE parent_id = ? AND nguoi_dung_id = ?',
//         [parent.id, userId]
//       );

//       categories.push({
//         id: parent.id,
//         name: parent.ten_danh_muc || "",
//         icon: parent.icon,
//         children: children.map(c => ({
//           id: c.id,
//           name: c.ten_danh_muc || "",
//           icon: c.icon
//         }))
//       });
//     }

//     res.json(categories);
//   } catch (err) {
//     console.error(err);
//     res.status(500).send('Server error');
//   }
// });

// // Thêm danh mục cha
// router.post('/', async (req, res) => {
//   const { userId, name, type, icon } = req.body;
//   try {
//     const [result] = await pool.query(
//       'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
//       [name, type, icon, userId, null]
//     );
//     res.json({ id: result.insertId, name, type, icon });
//   } catch (err) {
//     console.error(err);
//     res.status(500).send('Server error');
//   }
// });

// // Thêm danh mục con
// router.post('/:parentId/children', async (req, res) => {
//   const { parentId } = req.params;
//   const { userId, name, icon } = req.body;
//   try {
//     const [result] = await pool.query(
//       'INSERT INTO danh_muc (ten_danh_muc, loai, icon, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?, ?)',
//       [name, 'Chi', icon, parentId, userId]
//     );
//     res.json({ id: result.insertId, name, icon });
//   } catch (err) {
//     console.error(err);
//     res.status(500).send('Server error');
//   }
// });

// // Sửa danh mục
// router.put('/:id', async (req, res) => {
//   const { id } = req.params;
//   const { name, icon } = req.body;

//   try {
//     await pool.query(
//       'UPDATE danh_muc SET ten_danh_muc = ?, icon = ? WHERE id = ?',
//       [name, icon, id]
//     );
//     res.json({ id, name, icon });
//   } catch (err) {
//     console.error(err);
//     res.status(500).send('Server error');
//   }
// });

// // Xóa danh mục
// router.delete('/:id', async (req, res) => {
//   const { id } = req.params;

//   try {
//     await pool.query('DELETE FROM danh_muc WHERE parent_id = ?', [id]);
//     await pool.query('DELETE FROM danh_muc WHERE id = ?', [id]);

//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).send('Server error');
//   }
// });

// module.exports = router;              // ✅ export **chỉ router**
// module.exports.insertDefaultCategories = insertDefaultCategories; // export thêm hàm
// routes/category.js
const express = require('express');
const router = express.Router();
const pool = require('../db');

// Dữ liệu mặc định
const defaultCategories = [
  // Danh mục cha
  { name: 'Ăn uống', type: 'Chi', icon: 'fa-utensils', parentName: null },
  { name: 'Mua sắm', type: 'Chi', icon: 'fa-shopping-bag', parentName: null },
  { name: 'Nhà cửa', type: 'Chi', icon: 'fa-home', parentName: null },
  { name: 'Xe cộ', type: 'Chi', icon: 'fa-car', parentName: null },
  { name: 'Giải trí', type: 'Chi', icon: 'fa-film', parentName: null },
  { name: 'Y tế', type: 'Chi', icon: 'fa-notes-medical', parentName: null },
  { name: 'Học tập', type: 'Chi', icon: 'fa-book', parentName: null },
  { name: 'Lương thưởng', type: 'Thu', icon: 'fa-money-bill-wave', parentName: null },

  // Danh mục con
  { name: 'Cà phê', type: 'Chi', icon: 'fa-coffee', parentName: 'Ăn uống' },
  { name: 'Ăn sáng', type: 'Chi', icon: 'fa-bread-slice', parentName: 'Ăn uống' },
  { name: 'Ăn trưa', type: 'Chi', icon: 'fa-hamburger', parentName: 'Ăn uống' },
  { name: 'Ăn tối', type: 'Chi', icon: 'fa-pizza-slice', parentName: 'Ăn uống' },
  { name: 'Nước uống', type: 'Chi', icon: 'fa-wine-glass', parentName: 'Ăn uống' },
  { name: 'Quần áo', type: 'Chi', icon: 'fa-tshirt', parentName: 'Mua sắm' },
  { name: 'Giày dép', type: 'Chi', icon: 'fa-shoe-prints', parentName: 'Mua sắm' },
  { name: 'Điện thoại', type: 'Chi', icon: 'fa-mobile-alt', parentName: 'Mua sắm' },
  { name: 'Điện nước', type: 'Chi', icon: 'fa-bolt', parentName: 'Nhà cửa' },
  { name: 'Internet', type: 'Chi', icon: 'fa-wifi', parentName: 'Nhà cửa' },
  { name: 'Xăng xe', type: 'Chi', icon: 'fa-gas-pump', parentName: 'Xe cộ' },
  { name: 'Bảo dưỡng xe', type: 'Chi', icon: 'fa-tools', parentName: 'Xe cộ' },
  { name: 'Rạp chiếu phim', type: 'Chi', icon: 'fa-film', parentName: 'Giải trí' },
  { name: 'Du lịch', type: 'Chi', icon: 'fa-plane', parentName: 'Giải trí' },
  { name: 'Bác sĩ', type: 'Chi', icon: 'fa-user-doctor', parentName: 'Y tế' },
  { name: 'Thuốc men', type: 'Chi', icon: 'fa-pills', parentName: 'Y tế' },
  { name: 'Sách', type: 'Chi', icon: 'fa-book', parentName: 'Học tập' },
  { name: 'Văn phòng phẩm', type: 'Chi', icon: 'fa-pencil-alt', parentName: 'Học tập' },
  { name: 'Tiền lương', type: 'Thu', icon: 'fa-money-bill-wave', parentName: 'Lương thưởng' },
  { name: 'Thưởng', type: 'Thu', icon: 'fa-gift', parentName: 'Lương thưởng' },
];

// Hàm chèn dữ liệu mặc định cho user mới
async function insertDefaultCategories(userId) {
  const parentMap = {};
  for (const cat of defaultCategories) {
    let parentId = null;
    if (cat.parentName) parentId = parentMap[cat.parentName] || null;

    const [result] = await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
      [cat.name, cat.type, cat.icon, userId, parentId]
    );

    if (!cat.parentName) parentMap[cat.name] = result.insertId;
  }
}

// GET danh mục theo user và loại (Chi/Thu)
router.get('/', async (req, res) => {
  const { userId, type } = req.query;
  if (!userId || !type) {
    return res.status(400).send('Thiếu userId hoặc type');
  }

  try {
    // Lấy danh mục cha
    const [parents] = await pool.query(
      'SELECT * FROM danh_muc WHERE loai = ? AND nguoi_dung_id = ? AND (parent_id IS NULL OR parent_id = 0)',
      [type, userId]
    );
    console.log(`Found ${parents.length} parent categories for type=${type}`);

    const categories = [];

    for (let parent of parents) {
      const [children] = await pool.query(
        'SELECT * FROM danh_muc WHERE parent_id = ? AND nguoi_dung_id = ?',
        [parent.id, userId]
      );

      categories.push({
        id: parent.id,
        name: parent.ten_danh_muc || "",
        icon: parent.icon,
        children: children.map(c => ({
          id: c.id,
          name: c.ten_danh_muc || "",
          icon: c.icon,
        })),
      });
    }

    res.json(categories);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// Thêm danh mục cha
router.post('/', async (req, res) => {
  const { userId, name, type, icon } = req.body;
  if (!userId || !name || !type || !icon) return res.status(400).send('Thiếu dữ liệu');
  try {
    const [result] = await pool.query(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
      [name, type, icon, userId, null]
    );
    res.json({ id: result.insertId, name, type, icon });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// Thêm danh mục con
router.post('/:parentId/children', async (req, res) => {
  const { parentId } = req.params;
  const { userId, name, icon, type } = req.body;

  if (!parentId || !userId || !name || !icon) return res.status(400).send('Thiếu dữ liệu');

  try {
    let finalType = type;
    if (!finalType) {
      const [parent] = await pool.query('SELECT loai FROM danh_muc WHERE id = ?', [parentId]);
      finalType = parent[0]?.loai || 'Chi';
    }

    const [result] = await pool.query(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?, ?)',
      [name, finalType, icon, parentId, userId]
    );

    res.json({ id: result.insertId, name, icon, type: finalType });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// Sửa danh mục
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, icon } = req.body;

  if (!name || !icon) return res.status(400).send('Thiếu dữ liệu');

  try {
    await pool.query(
      'UPDATE danh_muc SET ten_danh_muc = ?, icon = ? WHERE id = ?',
      [name, icon, id]
    );
    res.json({ id, name, icon });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// Xóa danh mục
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    // Xóa danh mục con trước
    await pool.query('DELETE FROM danh_muc WHERE parent_id = ?', [id]);
    // Xóa danh mục cha
    await pool.query('DELETE FROM danh_muc WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

module.exports = router;
module.exports.insertDefaultCategories = insertDefaultCategories;
