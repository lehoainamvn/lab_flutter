import 'package:flutter/foundation.dart';
import 'item.dart';

class CatalogModel extends ChangeNotifier {
  static List<Item> _items = [
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

  /// Get item by [id].
  Item getById(String id) => _items.firstWhere((item) => item.id == id);

  /// Get item by its position in the catalog.
  Item getByPosition(int position) => _items[position];

  /// Get all items in the catalog.
  List<Item> get items => _items;

  /// Get the number of items in the catalog.
  int get itemCount => _items.length;
}
