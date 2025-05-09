import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/providers/cart_provider.dart';

class CheckoutModal extends StatefulWidget {
  final double totalAmount;
  final Function(bool, String)? onOrderResult;

  const CheckoutModal({
    super.key,
    required this.totalAmount,
    this.onOrderResult,
  });

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  String _selectedDelivery = 'Standard Delivery';
  String _selectedPayment = 'Mastercard';
  final String _userAddress = '123 Main Street, Springfield';

  void _selectDeliveryMethod() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Standard Delivery', 'Express Delivery'].map((method) {
          return ListTile(
            title: Text(method),
            onTap: () {
              setState(() => _selectedDelivery = method);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _selectPaymentMethod() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Mastercard', 'PayPal', 'Cash on Delivery'].map((method) {
          return ListTile(
            title: Text(method),
            onTap: () {
              setState(() => _selectedPayment = method);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitleRow(),
          const SizedBox(height: 8),
          _buildRow(title: 'Delivery', value: _selectedDelivery, onTap: _selectDeliveryMethod),
          const Divider(height: 28),
          _buildRow(title: 'Payment', value: _selectedPayment, onTap: _selectPaymentMethod),
          const Divider(height: 28),
          _buildRow(
            title: 'Total Cost',
            value: '\$${widget.totalAmount.toStringAsFixed(2)}',
            onTap: () {},
            isBold: true,
          ),
          const SizedBox(height: 20),
          _buildTermsText(),
          _buildPlaceOrderButton(),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        const Text(
          'Checkout',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        text: const TextSpan(
          text: 'By placing an order you agree to our ',
          style: TextStyle(fontSize: 12, color: AppColors.textLight),
          children: [
            TextSpan(
              text: 'Terms And Conditions',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Place Order',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('User not logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to place an order')),
      );
      return;
    }

    debugPrint('👤 Current user ID: ${user.uid}');

    try {
      // First, get the user's data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // If user document doesn't exist, create it with basic info
      if (!userDoc.exists) {
        debugPrint('⚠️ User document not found, creating new document');
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phone': user.phoneNumber ?? '',
          'email': user.email ?? '',
          'name': user.displayName ?? 'User ${user.uid.substring(0, 6)}',
          'address': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      final userData = userDoc.exists ? userDoc.data()! : {
        'phone': user.phoneNumber ?? '',
        'email': user.email ?? '',
        'name': user.displayName ?? 'User ${user.uid.substring(0, 6)}',
        'address': '',
      };
      
      debugPrint('📋 User data: $userData');

      debugPrint('🛒 Starting order creation...');
      final orderId = FirebaseFirestore.instance.collection('orders').doc().id;
      debugPrint('📝 Generated order ID: $orderId');
      
      final orderData = {
        'orderID': orderId,
        'userID': user.uid,
        'userName': userData['name'] ?? user.displayName ?? 'User ${user.uid.substring(0, 6)}',
        'userEmail': userData['email'] ?? user.email ?? '',
        'userPhone': userData['phone'] ?? user.phoneNumber ?? '',
        'address': _userAddress.isNotEmpty ? _userAddress : (userData['address'] ?? ''),
        'items': cart.items.values.map((item) => item.toJson()).toList(),
        'total': widget.totalAmount,
        'deliveryMethod': _selectedDelivery,
        'paymentMethod': _selectedPayment,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      };
      debugPrint('📦 Order data prepared: $orderData');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      debugPrint('✅ Order created successfully');
      cart.clearCart();
      if (mounted) {
        Navigator.pop(context);
        widget.onOrderResult?.call(true, orderId);
      }
    } catch (e) {
      debugPrint('❌ Error creating order: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    }
  }

  Widget _buildRow({
    required String title,
    String? value,
    required VoidCallback onTap,
    bool isBold = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
