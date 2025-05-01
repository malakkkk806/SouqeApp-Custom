class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> categories;
  final List<String> allergens;
  final String? suggestedProductId;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categories,
    required this.allergens,
    this.suggestedProductId,
  });

  // Helper method to format price
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  // Optional copyWith method
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? categories,
    List<String>? allergens,
    String? suggestedProductId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      allergens: allergens ?? this.allergens,
      suggestedProductId: suggestedProductId ?? this.suggestedProductId,
    );
  }
}
