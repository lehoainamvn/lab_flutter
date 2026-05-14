const express = require('express');
const router = express.Router();
const Item = require('../models/Item');

// Khởi tạo dữ liệu mẫu
const initializeItems = async () => {
  try {
    const count = await Item.countDocuments();
    if (count === 0) {
      const defaultItems = [
        { id: '1', name: 'Code Smell', color: 'red', price: 42 },
        { id: '2', name: 'Control Flow', color: 'pink', price: 42 },
        { id: '3', name: 'Interpreter', color: 'purple', price: 42 },
        { id: '4', name: 'Recursion', color: 'deepPurple', price: 42 },
        { id: '5', name: 'Sprint', color: 'indigo', price: 42 },
        { id: '6', name: 'Heisenbug', color: 'blue', price: 42 },
        { id: '7', name: 'Spaghetti', color: 'lightBlue', price: 42 },
        { id: '8', name: 'Hydra Code', color: 'cyan', price: 42 },
        { id: '9', name: 'Off-By-One', color: 'teal', price: 42 },
        { id: '10', name: 'Scope', color: 'green', price: 42 },
        { id: '11', name: 'Callback', color: 'lightGreen', price: 42 },
      ];

      await Item.insertMany(defaultItems);
      console.log('Default items initialized');
    }
  } catch (error) {
    console.error('Error initializing items:', error);
  }
};

// Gọi hàm khởi tạo
initializeItems();

// GET /api/items - Lấy tất cả items
router.get('/', async (req, res) => {
  try {
    const items = await Item.find().select('-__v');
    res.json(items);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/items/:id - Lấy item theo ID
router.get('/:id', async (req, res) => {
  try {
    const item = await Item.findOne({ id: req.params.id }).select('-__v');
    if (!item) {
      return res.status(404).json({ error: 'Item not found' });
    }
    res.json(item);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/items - Tạo item mới
router.post('/', async (req, res) => {
  try {
    const item = new Item(req.body);
    await item.save();
    res.status(201).json(item);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;