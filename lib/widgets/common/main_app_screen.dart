import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/tab_index_provider.dart';
import '/screens/cart/cart_screen.dart';
import '/screens/explore/explore_screen.dart';
import '/screens/favourite/favourite_screen.dart';
import '/screens/home/home_screen.dart';
import '/screens/profile/account_screen.dart';
import '/widgets/common/bottom_nav_bar.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    5,
    (_) => GlobalKey<NavigatorState>(),
  );

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    CartScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabIndexProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[tabProvider.index].currentState!.maybePop();
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: List.generate(_screens.length, (index) {
            return Offstage(
              offstage: tabProvider.index != index,
              child: Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (_) => _screens[index],
                  );
                },
              ),
            );
          }),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: tabProvider.index,
          onTap: (index) {
            if (index == tabProvider.index) {
              _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
            } else {
              tabProvider.setIndex(index);
            }
          },
        ),
      ),
    );
  }
}
