import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all products
  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      _productService.getProducts().listen(
        (products) {
          _products = products;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load featured products
  Future<void> loadFeaturedProducts() async {
    _setLoading(true);
    try {
      _featuredProducts = await _productService.getFeaturedProducts();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    _setLoading(true);
    try {
      final results = await _productService.searchProducts(query);
      _setLoading(false);
      return results;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return [];
    }
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _productService.getProductsByCategory(category);
  }

  // Get a single product by ID
  Future<Product?> getProduct(String productId) async {
    try {
      return await _productService.getProductById(productId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Get a product by name (used for relatedProducts)
  Product? getProductByName(String name) {
    try {
      return _products.firstWhere(
        (p) => p.name.toLowerCase() == name.toLowerCase(),
        orElse: () => Product(
          id: '',
          name: '',
          description: '',
          price: 0.0,
          imageUrl: '',
          category: '',
          stockQuantity: 0,
        ),
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
