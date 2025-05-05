import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqe/providers/cart_provider.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/models/cart_item_model.dart';
import 'package:souqe/widgets/cart/checkout_modal.dart';
import 'package:souqe/screens/cart/order_status_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _showOrderStatus(bool isSuccess, String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderStatusScreen(
          isSuccess: isSuccess,
          orderId: orderId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE0E0E0), thickness: 1),
        ),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () => _showClearCartDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 40, color: Color(0xFFE0E0E0)),
                    itemBuilder: (ctx, index) => _buildCartItem(items[index], cart),
                  ),
          ),
          if (cart.isNotEmpty) _buildCheckoutSection(cart),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, CartProvider cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildProductImage(item.imageUrl),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => cart.removeItem(item.productId),
                    child: const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${item.quantity} ${item.quantity > 1 ? 'pcs' : 'pc'}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _quantityButton('-', () {
                    if (item.quantity > 1) {
                      cart.decreaseQuantity(item.productId);
                    } else {
                      cart.removeItem(item.productId);
                    }
                  }),
                  const SizedBox(width: 12),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 12),
                  _quantityButton('+', () {
                    cart.incrementQuantity(item.productId);
                  }),
                  const Spacer(),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _imageErrorWidget(),
      );
    } else {
      return Image.asset(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _imageErrorWidget(),
      );
    }
  }

  Widget _imageErrorWidget() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _quantityButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: label == '+' ? AppColors.primaryLight : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => CheckoutModal(
              totalAmount: cart.totalAmount,
              onOrderResult: (bool isSuccess, String orderId) {
                Navigator.pop(context); // Close modal
                _showOrderStatus(isSuccess, orderId); // Show order result
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Go to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '\$${cart.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('CLEAR', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
