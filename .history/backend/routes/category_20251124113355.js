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

// Hàm chèn danh mục mặc định
async function insertDefaultCategories(userId) {
  const parentMap = {};

  // 1️⃣ Chèn danh mục cha
  for (const cat of defaultCategories.filter(c => !c.parentName)) {
    const [result] = await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
      [cat.name, cat.type, cat.icon, userId, null]
    );
    parentMap[cat.name] = result.insertId;
    console.log(`Đã chèn cha: ${cat.name} (id=${result.insertId})`);
  }

  // 2️⃣ Chèn danh mục con
  for (const cat of defaultCategories.filter(c => c.parentName)) {
    const parentId = parentMap[cat.parentName];
    if (!parentId) {
      console.error(`Không tìm thấy parentId cho ${cat.name}`);
      continue;
    }
    await pool.execute(
      'INSERT INTO danh_muc (ten_danh_muc, loai, icon, nguoi_dung_id, parent_id) VALUES (?, ?, ?, ?, ?)',
      [cat.name, cat.type, cat.icon, userId, parentId]
    );
    console.log(`Đã chèn con: ${cat.name} (parentId=${parentId})`);
  }
}

// Export
module.exports = router;
module.exports.insertDefaultCategories = insertDefaultCategories;
