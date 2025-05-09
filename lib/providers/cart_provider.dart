import 'package:flutter/foundation.dart';
import 'package:souqe/models/cart_item_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // Public Getters
  Map<String, CartItem> get items => Map.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.values.fold(0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  void addItem(CartItem item, {required String productId}) {
    try {
      // Validate input
      if (item.quantity <= 0) throw ArgumentError('Quantity must be positive');
      if (item.productId.isEmpty) throw ArgumentError('Product ID cannot be empty');

      final itemToAdd = item.copyWith(isSelected: item.isSelected);

      _items.update(
        item.productId,
        (existing) => existing.copyWith(
          quantity: existing.quantity + item.quantity,
          isSelected: existing.isSelected,
        ),
        ifAbsent: () => itemToAdd,
      );
      notifyListeners();
      debugPrint('Added ${item.name} (Qty: ${item.quantity})');
    } catch (e) {
      debugPrint('Failed to add item: $e');
      rethrow;
    }
  }

  void removeItem(String productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
      debugPrint('Removed item: $productId');
    }
  }

  void clearCart() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
      debugPrint('Cart cleared');
    }
  }

  // Quantity Operations
  void incrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    
    _items.update(
      productId,
      (existing) => existing.copyWith(
        quantity: existing.quantity + 1,
        isSelected: existing.isSelected,
      ),
    );
    notifyListeners();
    debugPrint('Increased quantity for: $productId');
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    final item = _items[productId]!;
    if (item.quantity > 1) {
      _items.update(
        productId,
        (existing) => existing.copyWith(
          quantity: existing.quantity - 1,
          isSelected: existing.isSelected,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    debugPrint('Decreased quantity for: $productId');
  }

  void setQuantity(String productId, int newQuantity) {
    if (!_items.containsKey(productId)) return;

    if (newQuantity <= 0) {
      removeItem(productId);
    } else {
      _items.update(
        productId,
        (existing) => existing.copyWith(
          quantity: newQuantity,
          isSelected: existing.isSelected,
        ),   
      );
      notifyListeners();
    }
    debugPrint('Set quantity for $productId to $newQuantity');
  }

  @override
  String toString() {
    return 'CartProvider(${_items.length} items, \$${totalAmount.toStringAsFixed(2)})';
  }
}