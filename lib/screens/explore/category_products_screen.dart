import 'package:flutter/material.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/models/category.dart'; // If needed for category data
import 'package:souqe/models/product.dart'; // Assuming you have product data
import 'package:souqe/providers/product_provider.dart'; // Ensure to use the provider for fetching products
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    
    // Filter products by category
    final categoryProducts = productProvider.getProductsByCategory(category.title);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        backgroundColor: AppColors.primary,
      ),
      body: categoryProducts.isEmpty
          ? const Center(child: Text('No products available in this category.'))
          : ListView.builder(
              itemCount: categoryProducts.length,
              itemBuilder: (ctx, index) {
                final product = categoryProducts[index];
                return ListTile(
                  leading: Image.asset(product.imageUrl),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  onTap: () {
                    // Handle navigation to Product Detail Screen
                  },
                );
              },
            ),
    );
  }
}
