import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/screens/cart/track_order_screen.dart';

class SelectOrderScreen extends StatelessWidget {
  const SelectOrderScreen({super.key});

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
      appBar: AppBar(title: const Text("Select Order to Track")),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders to track."));
          }

          final orders = snapshot.data!;

          return ListView.separated(
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
