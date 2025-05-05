import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/screens/cart/track_order_screen.dart';

class SelectOrderScreen extends StatelessWidget {
  const SelectOrderScreen({super.key});

  Future<List<QueryDocumentSnapshot>> _getUserOrders() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint('❌ No user ID found - user not logged in');
      return [];
    }

    debugPrint('👤 Fetching orders for user: $uid');
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userID', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .get();

      debugPrint('📦 Found ${snapshot.docs.length} orders');
      for (var doc in snapshot.docs) {
        debugPrint('Order ID: ${doc.id}, Data: ${doc.data()}');
      }
      return snapshot.docs;
    } catch (e) {
      debugPrint('❌ Error fetching orders: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Order to Track"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('❌ Error in FutureBuilder: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading orders: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.darkRed),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.selectOrder);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('ℹ️ No orders found for user');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No orders to track.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!;
          debugPrint('✅ Building list with ${orders.length} orders');

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              final total = data['total'] ?? 0.0;
              final date = (data['timestamp'] as Timestamp?)?.toDate();
              final dateStr = date != null ? DateFormat.yMMMd().add_jm().format(date) : 'Unknown';

              return ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text('Order #${order.id}'),
                subtitle: Text('Date: $dateStr'),
                trailing: Text('\$${total.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackOrderScreen(),
                      settings: RouteSettings(arguments: order.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
