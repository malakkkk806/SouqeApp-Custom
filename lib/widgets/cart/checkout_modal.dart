import 'package:flutter/material.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/app_routes.dart';

class CheckoutModal extends StatelessWidget {
  const CheckoutModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildRow(title: 'Delivery', value: 'Select Method', onTap: () {}),
          const Divider(height: 28),

          _buildRow(
            title: 'Payment',
            valueWidget: Image.asset(
              AppImages.mastercard,
              height: 20,
              width: 28,
            ),
            onTap: () {},
          ),
          const Divider(height: 28),

          _buildRow(title: 'Promo Code', value: 'Pick discount', onTap: () {}),
          const Divider(height: 28),

          _buildRow(
            title: 'Total Cost',
            value: '\$13.97',
            onTap: () {},
            isBold: true,
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RichText(
              text: const TextSpan(
                text: 'By placing an order you agree to our ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
                children: [
                  TextSpan(
                    text: 'Terms And Conditions',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close modal first
                Navigator.pushNamed(
                  context,
                  AppRoutes.orderStatus,
                  arguments: {'success': true}, // or false if failed
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String title,
    String? value,
    Widget? valueWidget,
    required VoidCallback onTap,
    bool isBold = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (valueWidget != null) valueWidget,
            if (value != null)
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
