const mongoose = require('mongoose');
require('dotenv').config();

// Kết nối MongoDB Atlas
mongoose.connect(process.env.MONGODB_URI)
.then(() => {
    console.log("✅ MongoDB Connected Successfully!");
})
.catch((err) => {
    console.log("❌ MongoDB Connection error:", err.message);
});

module.exports = mongoose.connection;