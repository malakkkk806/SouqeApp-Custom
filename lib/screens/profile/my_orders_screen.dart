import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:souqe/widgets/common/bottom_nav_bar.dart';
import 'package:souqe/constants/app_routes.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  Future<List<QueryDocumentSnapshot>> _getUserOrders() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userID', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Account tab
        onTap: (index) {
          final routes = ['/home', '/explore', '/cart', '/favorite', '/account'];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }

          final orders = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final doc = orders[index];
              final order = doc.data() as Map<String, dynamic>;
              final orderId = doc.id;
              final total = order['total']?.toStringAsFixed(2) ?? '0.00';
              final timestamp = (order['timestamp'] as Timestamp?)?.toDate();
              final status = order['status'] ?? 'pending';
              final items = List<Map<String, dynamic>>.from(order['items'] ?? []);

              return ExpansionTile(
                leading: const Icon(Icons.receipt_long),
                title: Text('Order #$orderId', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${timestamp?.toLocal().toString().split('.')[0] ?? 'No date'}\nStatus: $status',
                  style: const TextStyle(height: 1.5),
                ),
                trailing: Text('\$$total'),
                children: [
                  ...items.map((item) => ListTile(
                        title: Text('${item['title']}'),
                        subtitle: Text('x${item['quantity']}'),
                        trailing: Text('\$${item['price']?.toStringAsFixed(2)}'),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.trackOrder,
                          arguments: orderId,
                        );
                      },
                      child: const Text('Track this order'),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}