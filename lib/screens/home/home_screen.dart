import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/screens/explore/explore_screen.dart';
import 'package:souqe/widgets/common/bottom_nav_bar.dart';
import 'package:souqe/screens/home/product_detail_screen.dart';
import 'package:souqe/models/product.dart';
import 'package:souqe/providers/cart_provider.dart';
import 'package:souqe/models/cart_item.dart';
import 'package:souqe/screens/cart/cart_screen.dart';
import 'package:souqe/screens/profile/account_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<String> _favoriteProductIds = {};
  String _currentAddress = 'Fetching location...';

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
      setState(() => _currentAddress = 'Location permissions are permanently denied.');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    final place = placemarks.first;
    setState(() {
      _currentAddress = '${place.locality}, ${place.administrativeArea}, ${place.country}';
    });
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
                    const Icon(Icons.location_on,
                        color: AppColors.primary, size: 18),
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
              child: Image.asset(
                AppImages.banner1,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection("Exclusive Offer", products.sublist(0, 3)),
            const SizedBox(height: 20),
            _buildSection("Best Selling", products.sublist(3)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Product> productList) {
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
              onPressed: () {},
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
    final isFavorite = _favoriteProductIds.contains(product.id);

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
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.contain,
                    ),
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
                      setState(() {
                        if (isFavorite) {
                          _favoriteProductIds.remove(product.id);
                        } else {
                          _favoriteProductIds.add(product.id);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Removed ${product.name} from favorites'
                                : 'Added ${product.name} to favorites',
                            style: const TextStyle(fontSize: 13),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primary.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'VIEW FAVORITES',
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() => _currentIndex = 3);
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
                          final cart = Provider.of<CartProvider>(context,
                              listen: false);
                          cart.addItem(CartItem(
                            productId: product.id,
                            name: product.name,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            allergens: product.allergens,
                            quantity: 1,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added ${product.name} to cart',
                                style: const TextStyle(fontSize: 13),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() => _currentIndex = 2);
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
        //return const FavouriteScreen();
      case 4:
        return AccountScreen(userAddress: _currentAddress);
      default:
        return _buildShopContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildTabScreen(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
