// const express = require('express');
// const router = express.Router();
// const pool = require('../db');

// // Lấy danh sách tài khoản theo userId
// router.get('/:userId', async (req, res) => {
//   const { userId } = req.params;
//   try {
//     const [rows] = await pool.execute(
//       'SELECT id, ten_tai_khoan, loai_tai_khoan, so_du FROM tai_khoan WHERE nguoi_dung_id = ?',
//       [userId]
//     );
//     res.json({ success: true, accounts: rows });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   }
// });


// // Thêm tài khoản
// router.post('/', async (req, res) => {
//   const { nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
//   const conn = await pool.getConnection();
//   try {
//     await conn.beginTransaction();

//     // Lưu tài khoản
//     await conn.execute(
//       'INSERT INTO tai_khoan (nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du) VALUES (?, ?, ?, ?)',
//       [nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du]
//     );

//     // Thêm thông báo
//     const content = `Bạn đã thêm tài khoản ngân hàng: ${ten_tai_khoan}`;
//     await conn.execute(
//       'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
//       [nguoi_dung_id, content, 'Gợi ý']
//     );

//     await conn.commit();
//     res.json({ success: true, message: 'Tài khoản và thông báo lưu thành công' });
//   } catch (err) {
//     await conn.rollback();
//     console.error('❌ Lỗi lưu tài khoản:', err);
//     res.status(500).json({ success: false, message: 'Lỗi server' });
//   } finally {
//     conn.release();
//   }
// });

// // Sửa tài khoản
// router.put('/:id', async (req, res) => {
//   const { id } = req.params;
//   const { ten_tai_khoan, loai_tai_khoan, so_du } = req.body;
//   try {
//     await pool.execute(
//       'UPDATE tai_khoan SET ten_tai_khoan=?, loai_tai_khoan=?, so_du=? WHERE id=?',
//       [ten_tai_khoan, loai_tai_khoan, so_du, id]
//     );
//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false });
//   }
// });

// // Xóa tài khoản
// router.delete('/:id', async (req, res) => {
//   const { id } = req.params;
//   try {
//     await pool.execute('DELETE FROM tai_khoan WHERE id=?', [id]);
//     res.json({ success: true });
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ success: false });
//   }
// });

// module.exports = router;
const express = require('express');
const router = express.Router();
const pool = require('../db');

// ----------------- Lấy danh sách tài khoản theo userId -----------------
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;
  if (!userId) {
    return res.status(400).json({ success: false, message: 'Thiếu userId' });
  }

  try {
    const [rows] = await pool.execute(
      'SELECT id, ten_tai_khoan, loai_tai_khoan, so_du FROM tai_khoan WHERE nguoi_dung_id = ?',
      [userId]
    );
    res.json({ success: true, accounts: rows });
  } catch (err) {
    console.error('❌ Lỗi khi lấy danh sách tài khoản:', err);
    res.status(500).json({ success: false, message: 'Lỗi server khi lấy tài khoản' });
  }
});

// ----------------- Thêm tài khoản -----------------
router.post('/', async (req, res) => {
  const { nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du } = req.body;

  if (!nguoi_dung_id || !ten_tai_khoan || !loai_tai_khoan || so_du == null) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin bắt buộc' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // Lưu tài khoản
    await conn.execute(
      'INSERT INTO tai_khoan (nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du) VALUES (?, ?, ?, ?)',
      [nguoi_dung_id, ten_tai_khoan, loai_tai_khoan, so_du]
    );

    // Thêm thông báo
    const content = `Bạn đã thêm tài khoản ngân hàng: ${ten_tai_khoan}`;
    await conn.execute(
      'INSERT INTO thong_bao (nguoi_dung_id, noi_dung, loai, da_doc, ngay_tao) VALUES (?, ?, ?, 0, NOW())',
      [nguoi_dung_id, content, 'Gợi ý']
    );

    await conn.commit();
    res.json({ success: true, message: 'Tài khoản và thông báo lưu thành công' });
  } catch (err) {
    await conn.rollback();
    console.error('Lỗi lưu tài khoản:', err);
    res.status(500).json({ success: false, message: 'Lỗi server khi thêm tài khoản', error: err.message });
  } finally {
    conn.release();
  }
});

// ----------------- Sửa tài khoản -----------------
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { ten_tai_khoan, loai_tai_khoan, so_du } = req.body;

  if (!ten_tai_khoan || !loai_tai_khoan || so_du == null) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin cập nhật' });
  }

  try {
    const [result] = await pool.execute(
      'UPDATE tai_khoan SET ten_tai_khoan=?, loai_tai_khoan=?, so_du=? WHERE id=?',
      [ten_tai_khoan, loai_tai_khoan, so_du, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Tài khoản không tồn tại' });
    }

    res.json({ success: true, message: 'Cập nhật thành công' });
  } catch (err) {
    console.error('Lỗi khi sửa tài khoản:', err);
    res.status(500).json({ success: false, message: 'Lỗi server khi cập nhật tài khoản', error: err.message });
  }
});

// ----------------- Xóa tài khoản -----------------
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [result] = await pool.execute('DELETE FROM tai_khoan WHERE id=?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Tài khoản không tồn tại' });
    }

    res.json({ success: true, message: 'Xóa tài khoản thành công' });
  } catch (err) {
    console.error('Lỗi khi xóa tài khoản:', err);
    res.status(500).json({ success: false, message: 'Lỗi server khi xóa tài khoản', error: err.message });
  }
});

module.exports = router;
