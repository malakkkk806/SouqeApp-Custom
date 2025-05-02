import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_routes.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage(AppImages.defaultProfile) as ImageProvider,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'Guest User',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'No email available',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Account Options
          _buildOption(context, 'Edit Profile', Icons.edit, AppRoutes.profile),
          _buildOption(context, 'My Orders', Icons.shopping_bag_outlined, AppRoutes.orderStatus),
          _buildOption(context, 'Track Order', Icons.delivery_dining, AppRoutes.trackOrder),
          _buildOption(context, 'Help Center', Icons.help_outline, AppRoutes.help),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.darkRed),
            title: const Text('Logout', style: TextStyle(color: AppColors.darkRed)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          ),
        ],
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