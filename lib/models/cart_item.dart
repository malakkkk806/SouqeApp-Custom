class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  final List<String> allergens;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    required this.allergens,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'allergens': allergens,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        quantity: (json['quantity'] as num).toInt(),
        allergens: (json['allergens'] as List<dynamic>).cast<String>(),
      );

  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    List<String>? allergens,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      allergens: allergens ?? List.from(this.allergens),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}