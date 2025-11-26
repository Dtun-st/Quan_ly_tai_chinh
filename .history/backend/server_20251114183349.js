require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const registerRoute = require('./routes/register');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use('/api/register', registerRoute);

const loginRoute = require('./routes/login');
app.use('/api/login', loginRoute);
app.use('/api/bank', require('./routes/bank'));
const transactionRoute = require('./routes/transaction');
app.use('/api/transaction', transactionRoute);
const reportRoute = require('./routes/report');
app.use('/api/report', reportRoute);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server chạy tại http://localhost:${PORT}`);
});
