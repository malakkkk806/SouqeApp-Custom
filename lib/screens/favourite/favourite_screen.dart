import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqe/providers/favorites_provider.dart';
import 'package:souqe/widgets/common/bottom_nav_bar.dart';
import 'package:souqe/constants/app_routes.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  


  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: Image.asset(favorites[i].imageUrl),
                title: Text(favorites[i].name),
                subtitle: Text('\$${favorites[i].price}'),
              ),
            ),
      
    );
  }
}
