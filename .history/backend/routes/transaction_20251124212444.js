const express = require("express");
const multer = require("multer");
const cors = require("cors");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());

// Lưu folder uploads/
app.use("/uploads", express.static("uploads"));

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

// Fake DB
let transactions = [];
let id = 1;

// CREATE
app.post("/transactions", upload.single("billImage"), (req, res) => {
  const { amount, note } = req.body;

  const newData = {
    id: id++,
    amount: Number(amount),
    note,
    billImage: req.file ? `/uploads/${req.file.filename}` : null,
    createdAt: new Date()
  };

  transactions.push(newData);
  res.status(200).json(newData);
});

// READ all
app.get("/transactions", (req, res) => {
  res.json(transactions);
});

// UPDATE
app.put("/transactions/:id", upload.single("billImage"), (req, res) => {
  const id = Number(req.params.id);
  const index = transactions.findIndex(t => t.id === id);

  if (index === -1) return res.status(404).json({ message: "Not found" });

  transactions[index].amount = req.body.amount;
  transactions[index].note = req.body.note;

  if (req.file) {
    transactions[index].billImage = `/uploads/${req.file.filename}`;
  }

  res.json(transactions[index]);
});

// DELETE
app.delete("/transactions/:id", (req, res) => {
  const id = Number(req.params.id);
  transactions = transactions.filter(t => t.id !== id);
  res.json({ message: "Đã xóa" });
});

// SERVER
app.listen(3000, () => console.log("Server chạy cổng 3000"));
