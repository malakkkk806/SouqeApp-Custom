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

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'allergens': allergens,
      };

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'],
        name: json['name'],
        price: json['price'],
        imageUrl: json['imageUrl'],
        quantity: json['quantity'],
        allergens: List<String>.from(json['allergens']),
      );

  // Create a copy with optional changes
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
      allergens: allergens ?? this.allergens,
    );
  }
}
