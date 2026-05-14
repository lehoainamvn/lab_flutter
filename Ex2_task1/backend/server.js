const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const itemsRouter = require('./routes/items');
const cartRouter = require('./routes/cart');

app.use('/api/items', itemsRouter);
app.use('/api/cart', cartRouter);

// Health check endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'Flutter Shopping Cart API is running!',
    timestamp: new Date().toISOString()
  });
});

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
  console.log('Connected to MongoDB successfully');
  console.log('Database:', mongoose.connection.name);
})
.catch((error) => {
  console.error('MongoDB connection error:', error);
  process.exit(1);
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`API endpoints:`);
  console.log(`- GET    http://localhost:${PORT}/api/items`);
  console.log(`- GET    http://localhost:${PORT}/api/cart`);
  console.log(`- POST   http://localhost:${PORT}/api/cart`);
  console.log(`- DELETE http://localhost:${PORT}/api/cart/:itemId`);
  console.log(`- DELETE http://localhost:${PORT}/api/cart`);
});