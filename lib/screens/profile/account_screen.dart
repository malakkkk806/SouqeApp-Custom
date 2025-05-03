import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_routes.dart';

class AccountScreen extends StatelessWidget {
  final String userAddress;

  const AccountScreen({super.key, required this.userAddress});

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(user.uid),
        builder: (context, snapshot) {
          final data = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : const AssetImage(AppImages.defaultProfile) as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data?['name'] ?? user.displayName ?? 'Guest User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data?['email'] ?? user.email ?? 'No email',
                      style: const TextStyle(fontSize: 14, color: AppColors.textLight),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data?['phone'] ?? user.phoneNumber ?? 'No phone number',
                      style: const TextStyle(fontSize: 14, color: AppColors.textLight),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      userAddress.isNotEmpty ? userAddress : 'No address set',
                      style: const TextStyle(fontSize: 14, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildOption(context, 'My Orders', Icons.shopping_bag_outlined, AppRoutes.orderStatus),
              _buildOption(context, 'Track Order', Icons.delivery_dining, AppRoutes.trackOrder),

              const Divider(),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.darkRed),
                title: const Text('Logout', style: TextStyle(color: AppColors.darkRed)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontFamily: 'Inter')),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
