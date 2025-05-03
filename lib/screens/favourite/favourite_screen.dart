import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:souqe/providers/cart_provider.dart';
//import 'package:souqe/constants/colors.dart';
//import 'package:souqe/models/cart_item.dart';
import 'package:souqe/providers/favorites_provider.dart'; 
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(title: Text('My Favorites')),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites yet'))
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