class CartItemWidget {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  int quantity;
  final List<String> allergens;
  final bool isSelected;

  CartItemWidget({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.allergens,
    this.quantity = 1,
    this.isSelected = true,
  });

  double get totalPrice => price * quantity;

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

  factory CartItemWidget.fromJson(Map<String, dynamic> json) => CartItemWidget(
        productId: json['productId'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        category: json['category'] as String,
        quantity: (json['quantity'] as num).toInt(),
        allergens: (json['allergens'] as List<dynamic>).cast<String>(),
        isSelected: json['isSelected'] as bool? ?? true,
      );

  CartItemWidget copyWith({
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
    int? quantity,
    List<String>? allergens,
    bool? isSelected,
  }) {
    return CartItemWidget(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      allergens: allergens ?? List.from(this.allergens),
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemWidget &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;

  @override
  String toString() {
    return 'CartItem{'
        'productId: $productId, '
        'name: $name, '
        'price: $price, '
        'imageUrl: $imageUrl, '
        'category: $category, '
        'quantity: $quantity, '
        'allergens: $allergens, '
        'isSelected: $isSelected'
        '}';
  }
}