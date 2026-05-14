class Item {
  final String id;
  final String name;
  final String color;
  final int price;

  Item({
    required this.id,
    required this.name,
    required this.color,
    this.price = 42,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      price: json['price'] ?? 42,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'price': price,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Item(id: $id, name: $name, color: $color, price: $price)';
}