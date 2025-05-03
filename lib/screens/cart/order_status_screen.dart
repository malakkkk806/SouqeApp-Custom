import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/app_routes.dart';

class OrderStatusScreen extends StatefulWidget {
  final String? orderId;
  final bool isSuccess;
  
  const OrderStatusScreen({
    super.key, 
    this.orderId, 
    required this.isSuccess
  });

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  late Future<Map<String, dynamic>> _orderFuture;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _orderFuture = _fetchOrderDetails();
  }

  Future<Map<String, dynamic>> _fetchOrderDetails() async {
    try {
      if (widget.orderId == null) {
        throw Exception('No order ID provided');
      }

      final doc = await _firestore
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (!doc.exists) {
        throw Exception('Order not found');
      }

      return doc.data()!;
    } catch (e) {
      debugPrint('Error fetching order: $e');
      throw e;
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingDialog();
            }

            if (snapshot.hasError) {
              return _buildErrorDialog(context, snapshot.error.toString());
            }

            final orderData = snapshot.data!;
            final isSuccess = widget.isSuccess && orderData['status'] != 'failed';
            
            return isSuccess 
                ? _buildSuccessDialog(context, orderData)
                : _buildFailureDialog(context, orderData);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading order details...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDialog(BuildContext context, String error) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Order',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessDialog(BuildContext context, Map<String, dynamic> orderData) {
    final orderDate = (orderData['timestamp'] as Timestamp);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Image.asset(AppImages.orderSuccess, height: 100),
            const SizedBox(height: 20),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOrderDetailRow('Order ID', orderData['orderId'] ?? 'N/A'),
            _buildOrderDetailRow('Date', _formatDate(orderDate)),
            _buildOrderDetailRow('Total', '\$${orderData['total']?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context, 
                  AppRoutes.trackOrder,
                  arguments: widget.orderId,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('TRACK ORDER'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              ),
              child: const Text('BACK TO HOME'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureDialog(BuildContext context, Map<String, dynamic> orderData) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Image.asset(AppImages.orderFailed, height: 100),
            const SizedBox(height: 20),
            const Text(
              'Order Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              orderData['failureReason'] ?? 'Payment processing failed',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement retry logic here
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('TRY AGAIN'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              ),
              child: const Text('BACK TO HOME'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}