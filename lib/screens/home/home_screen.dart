import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/models/cart_item_model.dart';
import 'package:souqe/providers/cart_provider.dart';
import 'package:souqe/providers/tab_index_provider.dart';
import 'package:souqe/screens/explore/explore_screen.dart';
import 'package:souqe/screens/cart/cart_screen.dart';
import 'package:souqe/screens/profile/account_screen.dart';
import 'package:souqe/screens/favourite/favourite_screen.dart';
import 'package:souqe/screens/home/product_detail_screen.dart';
import 'package:souqe/screens/home/all_products_screen.dart';
import 'package:souqe/models/product.dart';
import 'package:souqe/providers/favorites_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;

  String _currentAddress = 'Fetching location...';

  final List<Product> products = [
    Product(
      id: 'prod_apple_001',
      name: 'Red Apples',
      description: 'Fresh red apples',
      price: 1.5,
      imageUrl: AppImages.apple,
      category: 'Fruits & Vegetables',
      stockQuantity: 100,
      isAvailable: true,
      rating: 4.6,
      reviewCount: 175,
      allergens: [],
      relatedProducts: ['Caramel Dip', 'Peanut Butter'],
      suggestedProductId: null, relatedProduct: [], categoryId: '',
    ),
    Product(
      id: 'prod_banana_001',
      name: 'Bananas',
      description: 'Fresh organic bananas',
      price: 1.2,
      imageUrl: AppImages.banana,
      category: 'Fruits & Vegetables',
      stockQuantity: 150,
      isAvailable: true,
      rating: 4.7,
      reviewCount: 200,
      allergens: [],
      relatedProducts: ['Peanut Butter', 'Yogurt'],
      suggestedProductId: 'prod_yogurt_001', relatedProduct: [], categoryId: '',
    ),
  Product(
    id: 'prod_beef_001',
    name: 'Ground Beef',
    description: 'Lean ground beef',
    price: 7.5,
    imageUrl: AppImages.beef,
    category: 'Meat & Seafood',
    stockQuantity: 100,
    isAvailable: true,
    rating: 4.6,
    reviewCount: 110,
    allergens: ['Meat'],
    relatedProducts: ['Burger Buns', 'Cheddar Cheese'],
    suggestedProductId: null, relatedProduct: [], categoryId: '',
  ),
  Product(
    id: 'prod_chicken_001',
    name: 'Broiler Chicken',
    description: 'Fresh and tender broiler chicken meat',
    price: 8.5,
    imageUrl: AppImages.chicken,
    category: 'Meat & Seafood',
    stockQuantity: 100,
    isAvailable: true,
    rating: 4.6,
    reviewCount: 180,
    allergens: ['Meat'],
    relatedProducts: ['Garlic', 'Lemon', 'Rosemary'],
    suggestedProductId: 'prod_cheese_001', relatedProduct: [], categoryId: '',
  ),
  Product(
    id: 'prod_pepper_001',
    name: 'Pepper',
    description: '1kg, Priceg',
    price: 4.99,
    imageUrl: AppImages.pepper,
    category: 'Condiments & Spices',
    stockQuantity: 60,
    isAvailable: true,
    rating: 4.5,
    reviewCount: 95,
    allergens: [],
    relatedProducts: ['Ginger'],
    suggestedProductId: null, relatedProduct: [], categoryId: '',
  ),
  Product(
    id: 'prod_ginger_001',
    name: 'Ginger',
    description: '0.5kg, Priceg',
    price: 4.99,
    imageUrl: AppImages.ginger,
    category: 'Condiments & Spices',
    stockQuantity: 70,
    isAvailable: true,
    rating: 4.5,
    reviewCount: 90,
    allergens: [],
    relatedProducts: ['Pepper'],
    suggestedProductId: null, relatedProduct: [], categoryId: '',
  ),
  Product(
    id: 'prod_pulses_001',
    name: 'Pulses',
    description: '1kg, Priceg',
    price: 3.99,
    imageUrl: AppImages.pulses,
    category: 'Pantry Staples',
    stockQuantity: 50,
    isAvailable: true,
    rating: 4.5,
    reviewCount: 100,
    allergens: [],
    relatedProducts: ['Rice'],
    suggestedProductId: null, relatedProduct: [], categoryId: '',
  ),
  Product(
    id: 'prod_rice_001',
    name: 'Basmati Rice',
    description: 'Long grain basmati rice',
    price: 2.0,
    imageUrl: AppImages.rice,
    category: 'Pantry Staples',
    stockQuantity: 130,
    isAvailable: true,
    rating: 4.6,
    reviewCount: 110,
    allergens: [],
    relatedProducts: ['Curry Powder', 'Lentils'],
    suggestedProductId: null, relatedProduct: [], categoryId: '',
  ),
];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _currentAddress = 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _currentAddress = 'Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(
        () => _currentAddress = 'Location permissions are permanently denied.',
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;
    setState(() {
      _currentAddress =
          '${place.locality}, ${place.administrativeArea}, ${place.country}';
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'address': _currentAddress,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Widget _buildShopContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset(AppImages.logo2, height: 50),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentAddress,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppImages.bagPhoto2,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection("Exclusive Offer", products.sublist(0, 4)),
            const SizedBox(height: 20),
            _buildSection("Best Selling", products.sublist(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Product> productList) {
    List<Product> extendedList = [];
    if (title == "Exclusive Offer") {
      extendedList = products.sublist(0, 6);
    } else if (title == "Best Selling") {
      extendedList = products.sublist(4);
      if (products.length > 6) {
        extendedList.addAll(products.sublist(6, 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllProductsScreen(
                      title: title,
                      products: extendedList,
                    ),
                  ),
                );
              },
              child: const Text(
                "See all",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 265,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: _buildProductCard(productList[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(product.id);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(product.imageUrl, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Removed ${product.name} from favorites'
                                : 'Added ${product.name} to favorites',
                            style: const TextStyle(fontSize: 13),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primary.withAlpha((0.9 * 255).round()),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'VIEW FAVORITES',
                            textColor: Colors.white,
                            onPressed: () {
                               Provider.of<TabIndexProvider>(context, listen: false).setIndex(3);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: AppColors.primary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          final cart = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );
                          cart.addItem(
                            CartItem(
                              productId: product.id,
                              name: product.name,
                              price: product.price,
                              imageUrl: product.imageUrl,
                              allergens: product.allergens,
                              quantity: 1,
                              category: product.category,
                            ),
                            productId: product.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added ${product.name} to cart',
                                style: const TextStyle(fontSize: 13),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary.withAlpha((0.9 * 255).round()),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                textColor: Colors.white,
                                onPressed: () {
                                   Provider.of<TabIndexProvider>(context, listen: false).setIndex(2);
                                },
                              ),
                              duration: const Duration(seconds: 2),
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

  Widget _buildTabScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildShopContent();
      case 1:
        return const ExploreScreen();
      case 2:
        return const CartScreen();
      case 3:
        return const FavoritesScreen();
      case 4:
        return AccountScreen();
      default:
        return _buildShopContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildTabScreen(),
    );
  }
}