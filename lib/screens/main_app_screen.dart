import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_index_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/app_colors.dart';
import 'home/home_screen.dart';
import 'explore/explore_screen.dart';
import 'cart/cart_screen.dart';
import 'favorites/favorites_screen.dart';
import 'account/account_screen.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({Key? key}) : super(key: key);

  Widget _buildTabScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ExploreScreen();
      case 2:
        return const CartScreen();
      case 3:
        return const FavoritesScreen();
      case 4:
        return const AccountScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TabIndexProvider>(
      builder: (context, tabProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: _buildTabScreen(tabProvider.currentIndex),
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
} 