import '../models/product.dart';

final List<Product> dummyProducts = [
  Product(
    id: 'chicken',
    name: 'Chicken Breast',
    description: 'Fresh and organic chicken breast meat.',
    price: 8.99,
    imageUrl: 'assets/images/chicken.png',
    categories: ['Meat'],
    allergens: ['Meat'],
    suggestedProductId: 'spices',
  ),
  Product(
    id: 'spices',
    name: 'Mixed Spices',
    description: 'A flavorful blend of organic spices.',
    price: 2.49,
    imageUrl: 'assets/images/spices.png',
    categories: ['Condiments'],
    allergens: [],
    suggestedProductId: null,
  ),
  Product(
    id: 'apple',
    name: 'Red Apple',
    description: 'Fresh and juicy red apples.',
    price: 1.99,
    imageUrl: 'assets/images/apple.png',
    categories: ['Fruits'],
    allergens: [],
    suggestedProductId: null,
  ),
  Product(
    id: 'oil',
    name: 'Cooking Oil',
    description: 'Pure sunflower cooking oil, 1L.',
    price: 3.49,
    imageUrl: 'assets/images/oil.png',
    categories: ['Cooking Oil'],
    allergens: [],
    suggestedProductId: null,
  ),
  // Add more products as needed
];
