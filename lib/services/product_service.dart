import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        });
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        });
  }

  // Get a single product by ID
  Future<Product?> getProductById(String productId) async {
    final doc = await _firestore.collection(_collection).doc(productId).get();
    if (doc.exists) {
      return Product.fromFirestore(doc);
    }
    return null;
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    query = query.toLowerCase();
    final snapshot = await _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .where((product) =>
            product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query))
        .toList();
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  // Add a new product (admin only)
  Future<String> addProduct(Product product) async {
    final docRef = await _firestore.collection(_collection).add(product.toFirestore());
    return docRef.id;
  }

  // Update a product (admin only)
  Future<void> updateProduct(String productId, Product product) async {
    await _firestore
        .collection(_collection)
        .doc(productId)
        .update(product.toFirestore());
  }

  // Delete a product (admin only)
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(_collection).doc(productId).delete();
  }

  // Update product stock
  Future<void> updateStock(String productId, int newQuantity) async {
    await _firestore
        .collection(_collection)
        .doc(productId)
        .update({'stockQuantity': newQuantity});
  }

  // Add or update product rating
  Future<void> updateProductRating(String productId, double newRating) async {
    final doc = await _firestore.collection(_collection).doc(productId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final currentRating = (data['rating'] ?? 0.0) as double;
      final currentCount = (data['reviewCount'] ?? 0) as int;
      
      final newCount = currentCount + 1;
      final updatedRating = ((currentRating * currentCount) + newRating) / newCount;

      await doc.reference.update({
        'rating': updatedRating,
        'reviewCount': newCount,
      });
    }
  }
}