import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'item.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items.
  int get totalPrice => _items.fold(0, (total, item) => total + item.price);

  /// The number of items in the cart.
  int get itemCount => _items.length;

  /// Adds [item] to cart. This is one of the ways to modify the cart from the outside.
  void add(Item item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes [item] from cart.
  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Checks if the cart contains a specific item.
  bool contains(Item item) {
    return _items.contains(item);
  }
}
