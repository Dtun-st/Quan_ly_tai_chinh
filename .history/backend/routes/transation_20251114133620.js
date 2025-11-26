// routes/transaction.js
const express = require('express');
const router = express.Router();

// Mock DB
let transactions = [];

// POST /api/transaction - Thêm giao dịch mới
router.post('/', (req, res) => {
  const { accountId, categoryId, type, amount, date, desc } = req.body;

  if (!accountId || !categoryId || !type || !amount || !date) {
    return res.status(400).json({ success: false, message: "Thiếu dữ liệu" });
  }

  const newTransaction = {
    id: transactions.length + 1,
    accountId,
    categoryId,
    type,
    amount,
    date,
    desc: desc || ''
  };

  transactions.push(newTransaction);

  res.json({ success: true, transaction: newTransaction });
});

// GET /api/transaction - Lấy danh sách giao dịch
router.get('/', (req, res) => {
  res.json(transactions);
});

module.exports = router;
