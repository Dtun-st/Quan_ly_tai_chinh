router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    // Lấy thông tin giao dịch trước khi xóa
    const [rows] = await pool.execute('SELECT * FROM giao_dich WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.json({ success: false, message: "Không tìm thấy giao dịch" });
    }
    const deletedTransaction = rows[0];

    // Xóa giao dịch
    await pool.execute('DELETE FROM giao_dich WHERE id = ?', [id]);

    // Trả về giao dịch vừa xóa
    res.json({ 
      success: true, 
      message: "Xóa thành công",
      deletedTransaction
    });
  } catch (err) {
    console.error("Lỗi DELETE:", err);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
});
