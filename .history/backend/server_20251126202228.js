require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const registerRoute = require('./routes/register');
const loginRoute = require('./routes/login');
const bankRoute = require('./routes/bank');
const transactionRoute = require('./routes/transaction');
const reportRoute = require('./routes/report');
const { router: categoryRoute } = require('./routes/category');
const profileRoute = require('./routes/profile');
const homeRoute = require('./routes/home');
const notificationRoute = require('./routes/notification');
const historyRoute = require('./routes/history');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use('/api/password', require('./routes/change_password'));
app.use('/api/register', registerRoute);
app.use('/api/login', loginRoute);
app.use('/api/bank', bankRoute);
app.use('/api/transaction', transactionRoute);
app.use('/api/report', reportRoute);
app.use('/api/categories', categoryRoute);
app.use('/api/profile', profileRoute);
app.use('/api/home', homeRoute);
const forgotRoute = require('./routes/forgot'); 
app.use('/api/forgot', forgotRoute);
app.use('/api/notification', notificationRoute);
app.use('/api/history', historyRoute);
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server chạy tại http://localhost:${PORT}`);
});
