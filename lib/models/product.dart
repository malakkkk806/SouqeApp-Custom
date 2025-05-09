import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String categoryId;
  final int stockQuantity;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final List<String> allergens;
  final List<String> relatedProducts;
  final String? suggestedProductId;

  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.categoryId,
    required this.stockQuantity,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.allergens = const [],
    this.relatedProducts = const [],
    this.suggestedProductId,
    this.calories,
    this.protein,
    this.carbs,
    this.fat, required List relatedProduct,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      categoryId: data['categoryId'] ?? '', 
      stockQuantity: data['stockQuantity'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      allergens: List<String>.from(data['allergens'] ?? []),
      relatedProducts: List<String>.from(data['relatedProducts'] ?? []),
      suggestedProductId: data['suggestedProductId'],
      calories: data['calories'],
      protein: (data['protein'] as num?)?.toDouble(),
      carbs: (data['carbs'] as num?)?.toDouble(),
      fat: (data['fat'] as num?)?.toDouble(), relatedProduct: [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'categoryId': categoryId,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'allergens': allergens,
      'relatedProducts': relatedProducts,
      'suggestedProductId': suggestedProductId,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'],
      category: map['category'],
      categoryId: map['categoryId'],
      stockQuantity: map['stockQuantity'],
      isAvailable: map['isAvailable'] ?? true,
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      allergens: List<String>.from(map['allergens'] ?? []),
      relatedProducts: List<String>.from(map['relatedProducts'] ?? []),
      suggestedProductId: map['suggestedProductId'],
      calories: map['calories'],
      protein: (map['protein'] as num?)?.toDouble(),
      carbs: (map['carbs'] as num?)?.toDouble(),
      fat: (map['fat'] as num?)?.toDouble(), relatedProduct: [],
    );
  }
}
