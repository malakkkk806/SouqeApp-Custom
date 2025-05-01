import 'package:flutter/material.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/constants/colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(AppImages.defaultProfile),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Afsar Hossen',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'lmshuvo97@gmail.com',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit, size: 20, color: AppColors.primary),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5, color: Colors.black12),

            _buildTile(context, Icons.list_alt, 'Orders', AppRoutes.orders),
            _buildTile(context, Icons.person_outline, 'My Details', AppRoutes.account),
            _buildTile(context, Icons.location_on_outlined, 'Delivery Address', AppRoutes.location),
            _buildTile(context, Icons.payment_outlined, 'Payment Methods', AppRoutes.paymentMethods),
            _buildTile(context, Icons.card_giftcard, 'Promo Cord', AppRoutes.promo),
            _buildTile(context, Icons.notifications_none, 'Notifications', AppRoutes.notifications),
            _buildTile(context, Icons.help_outline, 'Help', AppRoutes.help),
            _buildTile(context, Icons.info_outline, 'About', AppRoutes.about),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label, String route) {
    return Column(
      children: [
        ListTile(
          onTap: () => Navigator.pushNamed(context, route),
          leading: Icon(icon, color: Colors.black),
          title: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ),
        const Divider(height: 1, thickness: 0.5, color: Colors.black12),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 4,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: const TextStyle(fontFamily: 'Inter'),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Inter'),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Account'),
      ],
    );
  }
}
