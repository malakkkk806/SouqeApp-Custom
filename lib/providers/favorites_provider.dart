import 'package:flutter/material.dart';
import 'package:souqe/models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];

  // Get list of favorite products
  List<Product> get favorites => _favoriteProducts;

  // Add or remove a product from favorites
  void toggleFavorite(Product product) {
    final isExist = _favoriteProducts.any((item) => item.id == product.id);
    if (isExist) {
      _favoriteProducts.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteProducts.add(product);
    }
    notifyListeners();
  }

  // Check if a product is already a favorite
  bool isFavorite(String productId) {
    return _favoriteProducts.any((product) => product.id == productId);
  }

  // Clear all favorites
  void clearFavorites() {
    _favoriteProducts.clear();
    notifyListeners();
  }
}
