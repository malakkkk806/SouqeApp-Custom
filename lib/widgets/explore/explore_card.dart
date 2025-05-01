import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../constants/colors.dart';

class ExploreCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const ExploreCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: category.bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              category.image,
              height: 64,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
