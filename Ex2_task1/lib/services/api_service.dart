import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Lấy danh sách items từ MongoDB
  static Future<List<Item>> getItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Item.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching items: $e');
      // Trả về dữ liệu mặc định nếu API không hoạt động
      return _getDefaultItems();
    }
  }

  // Thêm item vào cart trong MongoDB
  static Future<bool> addToCart(Item item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Lấy items trong cart từ MongoDB
  static Future<List<Item>> getCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Item.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cart items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

  // Xóa item khỏi cart
  static Future<bool> removeFromCart(String itemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$itemId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Xóa tất cả items khỏi cart
  static Future<bool> clearCart() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Dữ liệu mặc định khi API không hoạt động
  static List<Item> _getDefaultItems() {
    return [
      Item(id: '1', name: 'Code Smell', color: 'red'),
      Item(id: '2', name: 'Control Flow', color: 'pink'),
      Item(id: '3', name: 'Interpreter', color: 'purple'),
      Item(id: '4', name: 'Recursion', color: 'deepPurple'),
      Item(id: '5', name: 'Sprint', color: 'indigo'),
      Item(id: '6', name: 'Heisenbug', color: 'blue'),
      Item(id: '7', name: 'Spaghetti', color: 'lightBlue'),
      Item(id: '8', name: 'Hydra Code', color: 'cyan'),
      Item(id: '9', name: 'Off-By-One', color: 'teal'),
      Item(id: '10', name: 'Scope', color: 'green'),
      Item(id: '11', name: 'Callback', color: 'lightGreen'),
    ];
  }
}
