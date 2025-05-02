import 'package:flutter/foundation.dart';
import 'package:souqe/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // Public Getters
  Map<String, CartItem> get items => Map.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.values.fold(0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  // Core Operations
  void addItem(CartItem item) {
    try {
      // Validate input
      if (item.quantity <= 0) throw ArgumentError('Quantity must be positive');
      if (item.productId.isEmpty) throw ArgumentError('Product ID cannot be empty');

      // Ensure isSelected is properly initialized
      final itemToAdd = item.copyWith(isSelected: item.isSelected);

      _items.update(
        item.productId,
        (existing) => existing.copyWith(
          quantity: existing.quantity + item.quantity,
          isSelected: existing.isSelected, // Preserve selection state
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
        isSelected: existing.isSelected, // Preserve selection state
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
          isSelected: existing.isSelected, // Preserve selection state
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
          isSelected: existing.isSelected, // Preserve selection state
        ),
      );
      notifyListeners();
    }
    debugPrint('Set quantity for $productId to $newQuantity');
  }

  // Selection Operations
  void toggleSelection(String productId) {
    if (_items.containsKey(productId)) {
      final current = _items[productId]!;
      _items[productId] = current.copyWith(isSelected: !current.isSelected);
      notifyListeners();
      debugPrint('Toggled selection for: $productId');
    }
  }

  void selectAll() {
    bool allSelected = _items.values.every((item) => item.isSelected);
    
    for (var item in _items.values) {
      _items[item.productId] = item.copyWith(isSelected: !allSelected);
    }
    notifyListeners();
    debugPrint(allSelected ? 'Deselected all items' : 'Selected all items');
  }

  void clearSelection() {
    bool hasSelected = _items.values.any((item) => item.isSelected);
    
    if (hasSelected) {
      for (var item in _items.values) {
        _items[item.productId] = item.copyWith(isSelected: false);
      }
      notifyListeners();
      debugPrint('Cleared all selections');
    }
  }

  // Utility Getters
  Map<String, CartItem> get selectedItems {
    return Map.from(_items)..removeWhere((_, item) => !item.isSelected);
  }

  int get selectedItemCount => selectedItems.length;

  double get selectedItemsAmount {
    return selectedItems.values.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Helper Methods
  bool containsItem(String productId) => _items.containsKey(productId);

  int getQuantity(String productId) => _items[productId]?.quantity ?? 0;

  bool isSelected(String productId) => _items[productId]?.isSelected ?? false;

  bool get allItemsSelected {
    if (_items.isEmpty) return false;
    return _items.values.every((item) => item.isSelected);
  }

  @override
  String toString() {
    return 'CartProvider(${_items.length} items, \$${totalAmount.toStringAsFixed(2)})';
  }
}