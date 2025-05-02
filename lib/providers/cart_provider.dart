import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(CartItem item) {
    if (_items.containsKey(item.productId)) {
      // Update quantity if item exists
      _items.update(
        item.productId,
        (existing) => existing.copyWith(quantity: existing.quantity + 1),
      );
    } else {
      // Add new item
      _items.putIfAbsent(item.productId, () => item);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    final item = _items[productId]!;
    if (item.quantity > 1) {
      _items.update(
        productId,
        (existing) => existing.copyWith(quantity: existing.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}