const express = require('express');
const router = express.Router();
const pool = require('../db'); // Chỉ khai báo 1 lần

// ======================
// ROUTES DANH MỤC
// ======================

// Lấy danh mục theo user
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM danh_muc WHERE nguoi_dung_id=?',
      [userId]
    );
    res.json({ success: true, categories: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Thêm danh mục
router.post('/', async (req, res) => {
  const { nguoi_dung_id, ten_danh_muc, loai, parent_id } = req.body;

  if (!nguoi_dung_id) {
    return res.status(400).json({ success: false, message: "Thiếu nguoi_dung_id" });
  }

  try {
    await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?)',
      [ten_danh_muc, loai, parent_id ?? null, nguoi_dung_id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Sửa danh mục
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { ten_danh_muc, icon } = req.body;

  try {
    const [rows] = await pool.execute(
      'SELECT nguoi_dung_id FROM danh_muc WHERE id=?',
      [id]
    );

    if (rows.length === 0)
      return res.status(404).json({ success: false, message: "Không tìm thấy danh mục" });

    if (!rows[0].nguoi_dung_id)
      return res.status(403).json({ success: false, message: "Danh mục hệ thống không được sửa" });

    await pool.execute(
      'UPDATE danh_muc SET ten_danh_muc=?, icon=? WHERE id=?',
      [ten_danh_muc, icon, id]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

// Xóa danh mục
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.execute(
      'SELECT nguoi_dung_id FROM danh_muc WHERE id=?',
      [id]
    );

    if (rows.length === 0)
      return res.status(404).json({ success: false, message: "Không tìm thấy danh mục" });

    if (!rows[0].nguoi_dung_id)
      return res.status(403).json({ success: false, message: "Danh mục hệ thống không được xóa" });

    await pool.execute('DELETE FROM danh_muc WHERE id=?', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false });
  }
});

async function insertDefaultCategories(userId) {
  // Mảng danh mục mẫu
  const defaultCategories = [
    // ===== Chi =====
    { ten_danh_muc: 'Ăn uống', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Mua sắm', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Nhà cửa', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Xe cộ', loai: 'Chi', parent_id: null },
    { ten_danh_muc: 'Giải trí', loai: 'Chi', parent_id: null },

    // Con của "Ăn uống"
    { ten_danh_muc: 'Cà phê', loai: 'Chi', parent_name: 'Ăn uống' },
    { ten_danh_muc: 'Ăn sáng', loai: 'Chi', parent_name: 'Ăn uống' },
    { ten_danh_muc: 'Ăn trưa', loai: 'Chi', parent_name: 'Ăn uống' },
    { ten_danh_muc: 'Ăn tối', loai: 'Chi', parent_name: 'Ăn uống' },
    { ten_danh_muc: 'Nước uống', loai: 'Chi', parent_name: 'Ăn uống' },

    // Con của "Mua sắm"
    { ten_danh_muc: 'Quần áo', loai: 'Chi', parent_name: 'Mua sắm' },
    { ten_danh_muc: 'Giày dép', loai: 'Chi', parent_name: 'Mua sắm' },
    { ten_danh_muc: 'Đồ điện tử', loai: 'Chi', parent_name: 'Mua sắm' },

    // Con của "Nhà cửa"
    { ten_danh_muc: 'Tiền thuê nhà', loai: 'Chi', parent_name: 'Nhà cửa' },
    { ten_danh_muc: 'Điện nước', loai: 'Chi', parent_name: 'Nhà cửa' },
    { ten_danh_muc: 'Sửa chữa', loai: 'Chi', parent_name: 'Nhà cửa' },

    // Con của "Xe cộ"
    { ten_danh_muc: 'Xăng xe', loai: 'Chi', parent_name: 'Xe cộ' },
    { ten_danh_muc: 'Bảo dưỡng', loai: 'Chi', parent_name: 'Xe cộ' },

    // ===== Thu =====
    { ten_danh_muc: 'Lương', loai: 'Thu', parent_id: null },
    { ten_danh_muc: 'Tiền lãi', loai: 'Thu', parent_id: null },
    { ten_danh_muc: 'Quà tặng', loai: 'Thu', parent_id: null },

    // Con của "Lương"
    { ten_danh_muc: 'Lương chính', loai: 'Thu', parent_name: 'Lương' },
    { ten_danh_muc: 'Thưởng', loai: 'Thu', parent_name: 'Lương' },

    // Con của "Tiền lãi"
    { ten_danh_muc: 'Tiền lãi ngân hàng', loai: 'Thu', parent_name: 'Tiền lãi' },
    { ten_danh_muc: 'Đầu tư', loai: 'Thu', parent_name: 'Tiền lãi' },
  ];

  const parentMap = {};

  for (const cat of defaultCategories) {
    let parentId = null;
    if (cat.parent_name) {
      parentId = parentMap[cat.parent_name];
    }

    const [result] = await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, parent_id, nguoi_dung_id) VALUES (?, ?, ?, ?)',
      [cat.ten_danh_muc, cat.loai, parentId, userId]
    );

    if (!cat.parent_name) {
      parentMap[cat.ten_danh_muc] = result.insertId;
    }
  }
}

module.exports = {
  router,
  insertDefaultCategories
};
