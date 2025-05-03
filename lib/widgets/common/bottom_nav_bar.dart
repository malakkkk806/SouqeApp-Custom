import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqe/providers/favorites_provider.dart';
import 'package:souqe/screens/cart/cart_screen.dart';
import 'package:souqe/screens/explore/explore_screen.dart';
import 'package:souqe/screens/favourite/favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(), // Your actual home content
          ExploreScreen(),     // Your explore screen
          CartScreen(),        // Your cart screen
          FavoritesScreen(),   // Your favorites screen
        ],
      ),
      bottomNavigationBar: Consumer<FavoritesProvider>(
        builder: (context, favorites, child) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
              if (index == 3) favorites.notifyListeners();
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
          );
        },
      ),
    );
  }
}