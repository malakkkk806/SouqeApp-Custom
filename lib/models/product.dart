import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stockQuantity;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final List<String> allergens;
  final List<String> relatedProducts;
  final String? suggestedProductId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stockQuantity,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.allergens = const [],
    this.relatedProducts = const [],
    this.suggestedProductId,
  });

  /// Returns formatted price like "$4.99"
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      stockQuantity: data['stockQuantity'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      allergens: List<String>.from(data['allergens'] ?? []),
      relatedProducts: List<String>.from(data['relatedProducts'] ?? []),
      suggestedProductId: data['suggestedProductId'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'allergens': allergens,
      'relatedProducts': relatedProducts,
      'suggestedProductId': suggestedProductId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
