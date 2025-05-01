import 'package:flutter/material.dart';
import 'package:souqe/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/profile.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reason Ahmed',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('ReasonTo@gmail.com'),
            const SizedBox(height: 8),
            const Text('01010101010'),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('My Address'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('My Orders'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('My Vouchers'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
                onPressed: () {},
                child: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}