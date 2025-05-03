<<<<<<< Updated upstream:lib/models/cart_item_model.dart

=======
import 'package:flutter/foundation.dart'; // Required for listEquals
>>>>>>> Stashed changes:lib/models/cart_item.dart
class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  int quantity;
  final List<String> allergens;
<<<<<<< Updated upstream:lib/models/cart_item_model.dart
  final bool isSelected;
=======
  bool isSelected;
>>>>>>> Stashed changes:lib/models/cart_item.dart

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.allergens,
<<<<<<< Updated upstream:lib/models/cart_item_model.dart
    this.quantity = 1,
    this.isSelected = true,
=======
    this.isSelected = false,
>>>>>>> Stashed changes:lib/models/cart_item.dart
  });

  // Calculates total price for this cart item
  double get totalPrice => price * quantity;

  // Converts object to JSON for storage
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
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
        category: json['category'] as String,
        quantity: (json['quantity'] as num).toInt(),
        allergens: (json['allergens'] as List<dynamic>).cast<String>(),
<<<<<<< Updated upstream:lib/models/cart_item_model.dart
        isSelected: json['isSelected'] as bool? ?? true,
=======
        isSelected: json['isSelected'] as bool? ?? false,
>>>>>>> Stashed changes:lib/models/cart_item.dart
      );

  // Creates a copy with updated values
  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
    int? quantity,
    List<String>? allergens,
    bool? isSelected,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
<<<<<<< Updated upstream:lib/models/cart_item_model.dart
      allergens: allergens ?? List.from(this.allergens),
=======
      allergens: allergens ?? List<String>.from(this.allergens),
>>>>>>> Stashed changes:lib/models/cart_item.dart
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
<<<<<<< Updated upstream:lib/models/cart_item_model.dart
  int get hashCode => productId.hashCode;

=======
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
>>>>>>> Stashed changes:lib/models/cart_item.dart
  @override
  String toString() {
    return 'CartItem{'
        'productId: $productId, '
        'name: $name, '
        'price: $price, '
<<<<<<< Updated upstream:lib/models/cart_item_model.dart
        'imageUrl: $imageUrl, '
        'category: $category, '
        'quantity: $quantity, '
        'allergens: $allergens, '
        'isSelected: $isSelected'
=======
        'quantity: $quantity, '
        'total: \$${totalPrice.toStringAsFixed(2)}, '
        'selected: $isSelected'
>>>>>>> Stashed changes:lib/models/cart_item.dart
        '}';
  }
}