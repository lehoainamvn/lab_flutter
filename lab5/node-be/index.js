require('dotenv').config();
const app = require("./app");
const db = require('./config/db'); // Đảm bảo kết nối DB chạy
const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});