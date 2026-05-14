const express = require('express');
const router = express.Router();
const Cart = require('../models/Cart');

// GET /api/cart - Lấy tất cả items trong cart
router.get('/', async (req, res) => {
  try {
    const cartItems = await Cart.find().select('-__v');
    res.json(cartItems);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/cart - Thêm item vào cart
router.post('/', async (req, res) => {
  try {
    const { id, name, color, price } = req.body;
    
    // Kiểm tra xem item đã có trong cart chưa
    const existingItem = await Cart.findOne({ itemId: id });
    if (existingItem) {
      return res.status(400).json({ error: 'Item already in cart' });
    }

    const cartItem = new Cart({
      itemId: id,
      name,
      color,
      price: price || 42
    });

    await cartItem.save();
    res.status(201).json(cartItem);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// DELETE /api/cart/:itemId - Xóa item khỏi cart
router.delete('/:itemId', async (req, res) => {
  try {
    const result = await Cart.deleteOne({ itemId: req.params.itemId });
    if (result.deletedCount === 0) {
      return res.status(404).json({ error: 'Item not found in cart' });
    }
    res.json({ message: 'Item removed from cart' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE /api/cart - Xóa tất cả items khỏi cart
router.delete('/', async (req, res) => {
  try {
    await Cart.deleteMany({});
    res.json({ message: 'Cart cleared' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;