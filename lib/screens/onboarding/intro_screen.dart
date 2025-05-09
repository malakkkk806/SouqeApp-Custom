import 'package:flutter/material.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/screens/onboarding/onboarding_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            SizedBox(height: size.height * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AppImages.logo,
                  height: size.height * 0.15,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SOUQÉ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 75,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Montserrat',
              ),
            ),
            
            const Spacer(flex: 3),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  onPressed: () => _navigateToOnboarding(context),
                  child: const Text('Get Started'),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
