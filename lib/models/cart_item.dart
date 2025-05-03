import 'package:flutter/foundation.dart'; // Required for listEquals
class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  final List<String> allergens;
  bool isSelected;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    required this.allergens,
    this.isSelected = false,
  });

  // Calculates total price for this cart item
  double get totalPrice => price * quantity;

  // Converts object to JSON for storage
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'allergens': allergens,
        'isSelected': isSelected,
      };

  // Creates object from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        quantity: (json['quantity'] as num).toInt(),
        allergens: (json['allergens'] as List<dynamic>).cast<String>(),
        isSelected: json['isSelected'] as bool? ?? false,
      );

  // Creates a copy with updated values
  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    List<String>? allergens,
    bool? isSelected,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      allergens: allergens ?? List<String>.from(this.allergens),
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        runtimeType == other.runtimeType &&
        productId == other.productId &&
        name == other.name &&
        price == other.price &&
        imageUrl == other.imageUrl &&
        quantity == other.quantity &&
        listEquals(allergens, other.allergens) &&
        isSelected == other.isSelected;
  }

  // Hash code implementation
  @override
  int get hashCode {
    return Object.hash(
      productId.hashCode,
      name.hashCode,
      price.hashCode,
      imageUrl.hashCode,
      quantity.hashCode,
      Object.hashAll(allergens),
      isSelected.hashCode,
    );
  }

  // For debugging purposes
  @override
  String toString() {
    return 'CartItem{'
        'productId: $productId, '
        'name: $name, '
        'price: $price, '
        'quantity: $quantity, '
        'total: \$${totalPrice.toStringAsFixed(2)}, '
        'selected: $isSelected'
        '}';
  }
}