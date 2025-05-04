import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/models/product.dart';
import 'package:souqe/providers/cart_provider.dart';
import 'package:souqe/models/cart_item_model.dart';
import 'package:souqe/providers/favorites_provider.dart';
import 'package:souqe/providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool hasSeenWarning = false;
  bool showSuggestion = false;
  bool isAddedToCart = false;
  bool isLoading = false;

  Future<void> _showAllergenWarning() async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      titleTextStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.primary,
      ),
      descTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppColors.textMedium,
      ),
      btnOkColor: AppColors.primary,
      btnOkText: 'Continue',
      buttonsTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      dialogBackgroundColor: AppColors.surface,
      title: 'Allergen Warning',
      desc: 'This product contains:\n${widget.product.allergens.map((e) => '• $e').join('\n')}',
      btnOkOnPress: () {
        setState(() {
          hasSeenWarning = true;
          if (widget.product.suggestedProductId != null) {
            showSuggestion = true;
          }
        });
      },
    ).show();
  }

  Future<void> _addToCart() async {
    setState(() => isLoading = true);
    
    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final product = widget.product;

      // Verify product availability
      final updatedProduct = await productProvider.getProduct(product.id);
      if (updatedProduct!.stockQuantity < quantity) {
        throw Exception('Not enough stock available');
      }

      final cartItem = CartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        category: product.category,
        quantity: quantity,
        allergens: product.allergens,
      );

      cart.addItem(cartItem, productId: cartItem.productId);
      
      setState(() => isAddedToCart = true);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added $quantity ${quantity > 1 ? 'items' : 'item'} of ${product.name}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.primary,
          action: SnackBarAction(
            label: 'VIEW CART',
            textColor: Colors.white,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      final wasFavorite = favoritesProvider.isFavorite(widget.product.id);
      
      favoritesProvider.toggleFavorite(widget.product);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wasFavorite ? 'Removed from favorites' : 'Added to favorites'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating favorites: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildNutritionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutritional Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                const Text('Calories'),
                Text('${widget.product.calories ?? 'N/A'} kcal'),
              ],
            ),
            TableRow(
              children: [
                const Text('Protein'),
                Text('${widget.product.protein ?? 'N/A'}g'),
              ],
            ),
            TableRow(
              children: [
                const Text('Carbohydrates'),
                Text('${widget.product.carbs ?? 'N/A'}g'),
              ],
            ),
            TableRow(
              children: [
                const Text('Fat'),
                Text('${widget.product.fat ?? 'N/A'}g'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              favoritesProvider.isFavorite(product.id) 
                  ? Icons.favorite 
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(product.imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (product.allergens.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Contains allergy',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(product.imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Allergen Warning
                  if (product.allergens.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Contains: ${product.allergens.join(', ')}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                  // Product Info
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(color: AppColors.textMedium),
                  ),
                  const SizedBox(height: 16),

                  // Price & Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textLight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${(product.price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Nutrition Info
                  const SizedBox(height: 24),
                  _buildNutritionInfo(),

                  // Reviews
                  const SizedBox(height: 24),
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < product.rating.floor()
                              ? Colors.orange
                              : Colors.grey.shade300,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${product.rating.toStringAsFixed(1)} (${product.reviewCount})'),
                    ],
                  ),

                  // Suggested Product
                  if (showSuggestion && product.suggestedProductId != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'You Might Also Like',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Suggested Product'),
                                Text('\$5.99', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ],

                  // Add to Cart Button
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading 
                          ? null 
                          : () {
                              if (product.allergens.isNotEmpty && !hasSeenWarning) {
                                _showAllergenWarning();
                              } else {
                                _addToCart();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAddedToCart ? Colors.green : AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              isAddedToCart ? '✓ Added to Cart' : 'Add To Basket',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}