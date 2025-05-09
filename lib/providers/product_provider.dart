import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
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
          relatedProduct: [], categoryId: '',
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
