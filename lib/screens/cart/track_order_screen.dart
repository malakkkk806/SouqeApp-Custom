import 'package:flutter/material.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_images.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Track Order',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image
            Center(child: Image.asset(AppImages.deliveryBike, height: 150)),
            const SizedBox(height: 30),

            // Order Status Timeline
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            _buildStatusTile(
              icon: Icons.check_circle,
              label: 'Order Placed',
              isDone: true,
            ),
            _buildStatusTile(
              icon: Icons.local_dining,
              label: 'Preparing',
              isDone: true,
            ),
            _buildStatusTile(
              icon: Icons.delivery_dining,
              label: 'On the Way',
              isDone: false,
            ),
            _buildStatusTile(
              icon: Icons.home,
              label: 'Delivered',
              isDone: false,
              isLast: true,
            ),

            const SizedBox(height: 32),

            // Delivery Address
            const Text(
              'Delivery Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '123 Main Street, Springfield, USA',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ETA
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.timer, size: 20, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Estimated Arrival: 20–30 mins',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile({
    required IconData icon,
    required String label,
    required bool isDone,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isDone ? AppColors.primary : AppColors.grey,
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? AppColors.primary : AppColors.grey,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              color: isDone ? AppColors.primary : AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
