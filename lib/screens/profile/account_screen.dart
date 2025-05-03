import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_routes.dart';

class AccountScreen extends StatelessWidget {
  final String userAddress;

  const AccountScreen({super.key, required this.userAddress});

  Future<Map<String, dynamic>> fetchUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        debugPrint('No user data found in Firestore');
        return {};
      }

      final data = doc.data() ?? {};
      debugPrint('Fetched user data: $data');
      return data;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view your account")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading profile: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.darkRed),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.account),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final userData = snapshot.data ?? {};
          final userName = userData['name'] ?? user.displayName ?? 'Guest User';
          final userEmail = userData['email'] ?? user.email ?? 'No email';
          final userPhone = userData['phone']?.toString() ?? 'No phone number';
          final userAddress = this.userAddress.isNotEmpty
              ? this.userAddress
              : userData['address'] ?? 'No address set';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: _getProfileImage(userData, user),
                        child: _getProfileImage(userData, user) == null
                            ? Text(
                                _getInitials(userName),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: userEmail,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: userPhone,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.location_on,
                        label: 'Address',
                        value: userAddress,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Account Options
              _buildSectionHeader('Orders'),
              _buildOptionTile(
                context,
                title: 'My Orders',
                icon: Icons.shopping_bag_outlined,
                route: AppRoutes.orderStatus,
              ),
              _buildOptionTile(
                context,
                title: 'Track Order',
                icon: Icons.delivery_dining,
                route: AppRoutes.trackOrder,
              ),

              const Divider(height: 40),

              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.darkRed),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.darkRed),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }

  ImageProvider? _getProfileImage(Map<String, dynamic> userData, User user) {
    if (userData['photoUrl'] != null) {
      return NetworkImage(userData['photoUrl']);
    } else if (user.photoURL != null) {
      return NetworkImage(user.photoURL!);
    } else {
      return const AssetImage(AppImages.account);
    }
  }

  String _getInitials(String name) {
    final nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '?';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts.last[0]}'.toUpperCase();
  }
}