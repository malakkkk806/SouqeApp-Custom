import 'package:flutter/material.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/constants/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to SOUQÉ',
      'description': 'Your smart grocery shopping assistant',
      'icon': Icons.shopping_cart_outlined,
    },
    {
      'title': 'Easy Shopping',
      'description': 'Find all your grocery needs in one place',
      'icon': Icons.search,
    },
    {
      'title': 'Fast Delivery',
      'description': 'Get your orders delivered quickly',
      'icon': Icons.delivery_dining,
    },
  ];

  void _goToSignIn() {
    Navigator.pushReplacementNamed(context, AppRoutes.signin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              page['icon'],
                              size: 80,
                              color: Colors.white.withAlpha(229),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              page['title'],
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              page['description'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontFamily: 'Inter',
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Icon(Icons.arrow_back),
                        )
                      else
                        const SizedBox(width: 56),

                      // Page indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),

                      // Next / Done Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _goToSignIn();
                          }
                        },
                        child: Icon(
                          _currentPage == _pages.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Skip Button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _goToSignIn,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
