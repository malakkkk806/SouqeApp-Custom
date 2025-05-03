import 'package:souqe/models/cart_item_model.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;

  const Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });

  Order copyWith({
    String? id,
    DateTime? date,
    List<CartItem>? items,
    double? total,
  }) {
    return Order(
      id: id ?? this.id,
      date: date ?? this.date,
      items: items ?? this.items,
      total: total ?? this.total,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((item) => CartItem(
                productId: item['productId'],
                name: item['name'],
                price: item['price'],
                imageUrl: item['imageUrl'],
                quantity: item['quantity'],
                allergens: List<String>.from(item['allergens']), 
                category: '',
              ))
          .toList(),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => {
            'productId': item.productId,
            'name': item.name,
            'price': item.price,
            'imageUrl': item.imageUrl,
            'quantity': item.quantity,
            'allergens': item.allergens,
          }).toList(),
      'total': total,
    };
  }
}
