import 'package:flutter/material.dart';
import 'package:souqe/models/product.dart'; // adjust this path to where your Product class is

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];

  List<Product> get favorites => _favoriteProducts;

  void toggleFavorite(Product product) {
    final isExist = _favoriteProducts.any((item) => item.id == product.id);
    if (isExist) {
      _favoriteProducts.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteProducts.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.any((product) => product.id == productId);
  }
}
