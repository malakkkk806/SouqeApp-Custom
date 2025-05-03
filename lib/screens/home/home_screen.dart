import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/models/product.dart';
import 'package:souqe/providers/cart_provider.dart';
import 'package:souqe/models/cart_item.dart';
import 'package:souqe/screens/cart/cart_screen.dart';
import 'package:souqe/screens/home/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Red Apple',
      description: '1kg, Priceg',
      price: 4.99,
      imageUrl: AppImages.apple,
      categories: ['Fruits'],
      allergens: [],
    ),
    Product(
      id: '2',
      name: 'Organic Bananas',
      description: '7pcs, Priceg',
      price: 4.99,
      imageUrl: AppImages.banana,
      categories: ['Fruits'],
      allergens: [],
    ),
    Product(
      id: '3',
      name: 'Beef Bone',
      description: '1kg, Priceg',
      price: 4.99,
      imageUrl: AppImages.beef,
      categories: ['Meat'],
      allergens: [],
    ),
    Product(
      id: '4',
      name: 'Broiler Chicken',
      description: '1kg, Priceg',
      price: 4.99,
      imageUrl: AppImages.chicken,
      categories: ['Meat'],
      allergens: [],
    ),
    Product(
      id: '5',
      name: 'Pepper',
      description: '1kg, Priceg',
      price: 4.99,
      imageUrl: AppImages.pepper,
      categories: ['Species'],
      allergens: [],
    ),
    Product(
      id: '6',
      name: 'Ginger',
      description: '0.5kg, Priceg',
      price: 4.99,
      imageUrl: AppImages.ginger,
      categories: ['Species'],
      allergens: [],
    ),
  ];

  Widget _buildTabScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildShopContent();
      case 1:
        return const Center(child: Text("Explore Screen"));
      case 2:
        return const CartScreen();
      case 3:
        return const Center(child: Text("Favourite Screen"));
      case 4:
        return const Center(child: Text("Account Screen"));
      default:
        return _buildShopContent();
    }
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12)),
                child: Image.asset(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                       IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.primary),
                        onPressed: () {
                          final cart = Provider.of<CartProvider>(context, listen: false);
                          cart.addItem(
                            CartItem(
                               productId: product.id,
                               name: product.name,
                               price: product.price,
                               category: product.categories.isNotEmpty 
                                  ? product.categories.first 
                                  : 'Uncategorized',
                               imageUrl: product.imageUrl,
                               allergens: product.allergens,
                               quantity: 1,
                      ),
                      productId: product.id, // This matches your CartProvider's addItem signature
                         );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${product.name} to cart'),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                onPressed: () {
                                  setState(() => _currentIndex = 2);
                                },
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Product> productList, {bool isGrocery = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("See all", style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isGrocery) _buildCategoryChips(),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = productList[index];
              return SizedBox(
                width: 160,
                child: _buildProductCard(product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      {
        'title': 'Pulses',
        'color': AppColors.surface,
        'icon': AppImages.pulses,
      },
      {
        'title': 'Rice',
        'color': AppColors.secondary.withOpacity(0.15),
        'icon': AppImages.rice,
      },
      {
        'title': 'Oils',
        'color': AppColors.primaryLight.withOpacity(0.1),
        'icon': AppImages.oil,
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 34),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category['color'] as Color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    category['icon'] as String,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Image.asset(AppImages.logo2, height: 60),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, color: AppColors.primary, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Shoubra, Faculty Of Enginnering',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Store',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(AppImages.banner1, height: 150, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          _buildSection("Exclusive Offer", products.sublist(0, 2)),
          const SizedBox(height: 24),
          _buildSection("Best Selling", products.sublist(0, 2)),
          const SizedBox(height: 24),
          _buildSection("Groceries", products.sublist(2), isGrocery: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildTabScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
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
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}