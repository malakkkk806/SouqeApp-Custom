import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final List<Map<String, dynamic>> initialProducts = [
  // --- Fruits & Vegetables ---
  {
    "id": "prod_banana_001",
    "name": "Bananas",
    "description": "Fresh organic bananas",
    "price": 1.2,
    "imageUrl": "https://images.pexels.com/photos/41957/banana-fruit-food-healthy-41957.jpeg",
    "category": "Fruits & Vegetables",
    "stockQuantity": 150,
    "isAvailable": true,
    "rating": 4.7,
    "reviewCount": 200,
    "allergens": [],
    "relatedProduct": ["Peanut Butter", "Yogurt"],
    "suggestedProductId": "prod_yogurt_001"
  },
  {
    "id": "prod_carrot_001",
    "name": "Carrots",
    "description": "Crunchy organic carrots",
    "price": 0.9,
    "imageUrl": "https://images.pexels.com/photos/65174/pexels-photo-65174.jpeg",
    "category": "Fruits & Vegetables",
    "stockQuantity": 120,
    "isAvailable": true,
    "rating": 4.5,
    "reviewCount": 150,
    "allergens": [],
    "relatedProducts": ["Hummus", "Celery"],
    "suggestedProductId": null
  },
  {
    "id": "prod_apple_001",
    "name": "Red Apples",
    "description": "Fresh red apples",
    "price": 1.5,
    "imageUrl": "https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg",
    "category": "Fruits & Vegetables",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 175,
    "allergens": [],
    "relatedProducts": ["Caramel Dip", "Peanut Butter"],
    "suggestedProductId": null
  },
  {
    "id": "prod_spinach_001",
    "name": "Spinach",
    "description": "Fresh organic spinach leaves",
    "price": 2.0,
    "imageUrl": "https://images.pexels.com/photos/1435895/pexels-photo-1435895.jpeg",
    "category": "Fruits & Vegetables",
    "stockQuantity": 60,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 90,
    "allergens": [],
    "relatedProducts": ["Feta Cheese", "Olive Oil"],
    "suggestedProductId": "prod_oil_001"
  },

  // --- Meat & Seafood ---
  {
    "id": "prod_chicken_001",
    "name": "Broiler Chicken",
    "description": "Fresh and tender broiler chicken meat",
    "price": 8.5,
    "imageUrl": "https://images.pexels.com/photos/65175/pexels-photo-65175.jpeg",
    "category": "Meat & Seafood",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 180,
    "allergens": ["Meat"],
    "relatedProducts": ["Garlic", "Lemon", "Rosemary"],
    "suggestedProductId": "prod_cheese_001"
  },
  {
    "id": "prod_salmon_001",
    "name": "Salmon Fillet",
    "description": "Fresh Atlantic salmon fillet",
    "price": 12.0,
    "imageUrl": "https://images.pexels.com/photos/65175/pexels-photo-65175.jpeg",
    "category": "Meat & Seafood",
    "stockQusantity": 80,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 90,
    "allergens": ["Fish"],
    "relatedProducts": ["Lemon", "Dill"],
    "suggestedProductId": null
  },
  {
    "id": "prod_beef_001",
    "name": "Ground Beef",
    "description": "Lean ground beef",
    "price": 7.5,
    "imageUrl": "https://images.pexels.com/photos/616404/pexels-photo-616404.jpeg",
    "category": "Meat & Seafood",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 110,
    "allergens": ["Meat"],
    "relatedProducts": ["Burger Buns", "Cheddar Cheese"],
    "suggestedProductId": null
  },
  {
    "id": "prod_shrimp_001",
    "name": "Shrimp",
    "description": "Fresh jumbo shrimp",
    "price": 9.99,
    "imageUrl": "https://images.pexels.com/photos/3577430/pexels-photo-3577430.jpeg",
    "category": "Meat & Seafood",
    "stockQuantity": 60,
    "isAvailable": true,
    "rating": 4.7,
    "reviewCount": 75,
    "allergens": ["Shellfish"],
    "relatedProducts": ["Cocktail Sauce", "Lemon"],
    "suggestedProductId": null
  },

    // --- Dairy & Eggs ---
  {
    "id": "prod_milk_001",
    "name": "Whole Milk",
    "description": "Fresh whole milk",
    "price": 2.5,
    "imageUrl": "https://images.pexels.com/photos/416656/pexels-photo-416656.jpeg",
    "category": "Dairy & Eggs",
    "stockQuantity": 200,
    "isAvailable": true,
    "rating": 4.7,
    "reviewCount": 180,
    "allergens": ["Dairy"],
    "relatedProducts": ["Cereal", "Cookies"],
    "suggestedProductId": null
  },
  {
    "id": "prod_eggs_001",
    "name": "Eggs (Dozen)",
    "description": "Free-range eggs",
    "price": 3.0,
    "imageUrl": "https://images.pexels.com/photos/162712/eggs-egg-carton-chicken-eggs-162712.jpeg",
    "category": "Dairy & Eggs",
    "stockQuantity": 180,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 160,
    "allergens": ["Eggs"],
    "relatedProducts": ["Bacon", "Toast"],
    "suggestedProductId": null
  },
  {
    "id": "prod_cheese_001",
    "name": "Feta Cheese",
    "description": "Tangy and creamy Greek feta cheese",
    "price": 5.0,
    "imageUrl": "https://images.pexels.com/photos/1739748/pexels-photo-1739748.jpeg",
    "category": "Dairy & Eggs",
    "stockQuantity": 50,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 95,
    "allergens": ["Dairy"],
    "relatedProducts": ["Olives", "Tomatoes"],
    "suggestedProductId": null
  },
  {
    "id": "prod_yogurt_001",
    "name": "Greek Yogurt",
    "description": "Thick and creamy Greek yogurt",
    "price": 1.5,
    "imageUrl": "https://images.pexels.com/photos/704569/pexels-photo-704569.jpeg",
    "category": "Dairy & Eggs",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.9,
    "reviewCount": 140,
    "allergens": ["Dairy"],
    "relatedProducts": ["Granola", "Berries"],
    "suggestedProductId": null
  },

  // --- Bakery ---
  {
    "id": "prod_bread_001",
    "name": "Whole Wheat Bread",
    "description": "Soft and healthy whole wheat bread loaf",
    "price": 3.0,
    "imageUrl": "https://images.pexels.com/photos/2434/bread-food-healthy-breakfast.jpg",
    "category": "Bakery",
    "stockQuantity": 70,
    "isAvailable": true,
    "rating": 4.5,
    "reviewCount": 75,
    "allergens": ["Gluten"],
    "relatedProducts": ["Butter", "Jam"],
    "suggestedProductId": null
  },
  {
    "id": "prod_baguette_001",
    "name": "French Baguette",
    "description": "Crispy French baguette",
    "price": 2.0,
    "imageUrl": "https://images.pexels.com/photos/2434/bread-food-healthy-breakfast.jpg",
    "category": "Bakery",
    "stockQuantity": 90,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 130,
    "allergens": ["Gluten"],
    "relatedProducts": ["Brie Cheese", "Olive Oil"],
    "suggestedProductId": null
  },
  {
    "id": "prod_croissant_001",
    "name": "Butter Croissant",
    "description": "Flaky butter croissant",
    "price": 1.5,
    "imageUrl": "https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg",
    "category": "Bakery",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.7,
    "reviewCount": 140,
    "allergens": ["Gluten", "Dairy"],
    "relatedProducts": ["Jam", "Coffee"],
    "suggestedProductId": null
  },
  {
    "id": "prod_muffin_001",
    "name": "Blueberry Muffin",
    "description": "Sweet and soft blueberry muffin",
    "price": 2.2,
    "imageUrl": "https://images.pexels.com/photos/1628064/pexels-photo-1628064.jpeg",
    "category": "Bakery",
    "stockQuantity": 80,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 90,
    "allergens": ["Gluten", "Dairy", "Eggs"],
    "relatedProducts": ["Coffee", "Milk"],
    "suggestedProductId": null
  },

    // --- Pantry Staples ---
  {
    "id": "prod_pasta_001",
    "name": "Spaghetti Pasta",
    "description": "Durum wheat spaghetti",
    "price": 1.2,
    "imageUrl": "https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg",
    "category": "Pantry Staples",
    "stockQuantity": 150,
    "isAvailable": true,
    "rating": 4.5,
    "reviewCount": 100,
    "allergens": ["Gluten"],
    "relatedProducts": ["Tomato Sauce", "Parmesan Cheese"],
    "suggestedProductId": null
  },
  {
    "id": "prod_rice_001",
    "name": "Basmati Rice",
    "description": "Long grain basmati rice",
    "price": 2.0,
    "imageUrl": "https://images.pexels.com/photos/4197925/pexels-photo-4197925.jpeg",
    "category": "Pantry Staples",
    "stockQuantity": 130,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 110,
    "allergens": [],
    "relatedProducts": ["Curry Powder", "Lentils"],
    "suggestedProductId": null
  },

  // --- Beverages ---
  {
    "id": "prod_juice_001",
    "name": "Orange Juice",
    "description": "Freshly squeezed orange juice",
    "price": 3.0,
    "imageUrl": "https://images.pexels.com/photos/96974/pexels-photo-96974.jpeg",
    "category": "Beverages",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.7,
    "reviewCount": 120,
    "allergens": [],
    "relatedProducts": ["Croissant", "Eggs"],
    "suggestedProductId": null
  },
  {
    "id": "prod_tea_001",
    "name": "Green Tea",
    "description": "Organic green tea bags",
    "price": 2.5,
    "imageUrl": "https://images.pexels.com/photos/1417945/pexels-photo-1417945.jpeg",
    "category": "Beverages",
    "stockQuantity": 90,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 100,
    "allergens": [],
    "relatedProducts": ["Honey", "Lemon"],
    "suggestedProductId": null
  },

  // --- Frozen Foods ---
  {
    "id": "prod_frozen_peas_001",
    "name": "Frozen Green Peas",
    "description": "Frozen organic green peas",
    "price": 1.5,
    "imageUrl": "https://images.pexels.com/photos/103124/pexels-photo-103124.jpeg",
    "category": "Frozen Foods",
    "stockQuantity": 120,
    "isAvailable": true,
    "rating": 4.5,
    "reviewCount": 90,
    "allergens": [],
    "relatedProducts": ["Carrots", "Corn"],
    "suggestedProductId": null
  },
  {
    "id": "prod_frozen_pizza_001",
    "name": "Frozen Margherita Pizza",
    "description": "Classic margherita frozen pizza",
    "price": 4.0,
    "imageUrl": "https://images.pexels.com/photos/2619967/pexels-photo-2619967.jpeg",
    "category": "Frozen Foods",
    "stockQuantity": 80,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 100,
    "allergens": ["Gluten", "Dairy"],
    "relatedProducts": ["Garlic Bread", "Soda"],
    "suggestedProductId": null
  },

  // --- Snacks & Sweets ---
  {
    "id": "prod_chocolate_001",
    "name": "Milk Chocolate Bar",
    "description": "Creamy milk chocolate bar",
    "price": 1.0,
    "imageUrl": "https://images.pexels.com/photos/4109994/pexels-photo-4109994.jpeg",
    "category": "Snacks & Sweets",
    "stockQuantity": 150,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 130,
    "allergens": ["Dairy"],
    "relatedProducts": ["Cookies", "Milk"],
    "suggestedProductId": null
  },
  {
    "id": "prod_chips_001",
    "name": "Potato Chips",
    "description": "Crispy salted potato chips",
    "price": 1.5,
    "imageUrl": "https://images.pexels.com/photos/678414/pexels-photo-678414.jpeg",
    "category": "Snacks & Sweets",
    "stockQuantity": 130,
    "isAvailable": true,
    "rating": 4.4,
    "reviewCount": 85,
    "allergens": [],
    "relatedProducts": ["Soda", "Dip"],
    "suggestedProductId": null
  },

  // --- Condiments & Spices ---
  {
    "id": "prod_ketchup_001",
    "name": "Tomato Ketchup",
    "description": "Classic tomato ketchup bottle",
    "price": 2.0,
    "imageUrl": "https://images.pexels.com/photos/4791265/pexels-photo-4791265.jpeg",
    "category": "Condiments & Spices",
    "stockQuantity": 110,
    "isAvailable": true,
    "rating": 4.5,
    "reviewCount": 95,
    "allergens": [],
    "relatedProducts": ["Fries", "Hot Dog"],
    "suggestedProductId": null
  },
  {
    "id": "prod_salt_001",
    "name": "Sea Salt",
    "description": "Pure sea salt",
    "price": 1.0,
    "imageUrl": "https://images.pexels.com/photos/4109881/pexels-photo-4109881.jpeg",
    "category": "Condiments & Spices",
    "stockQuantity": 140,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 90,
    "allergens": [],
    "relatedProducts": ["Pepper", "Garlic Powder"],
    "suggestedProductId": null
  },

  // --- Health & Personal Care ---
  {
    "id": "prod_shampoo_001",
    "name": "Herbal Shampoo",
    "description": "Gentle herbal shampoo",
    "price": 5.0,
    "imageUrl": "https://images.pexels.com/photos/6621462/pexels-photo-6621462.jpeg",
    "category": "Health & Personal Care",
    "stockQuantity": 90,
    "isAvailable": true,
    "rating": 4.7,
    "reviewCount": 110,
    "allergens": [],
    "relatedProducts": ["Conditioner", "Hair Oil"],
    "suggestedProductId": null
  },
  {
    "id": "prod_toothpaste_001",
    "name": "Mint Toothpaste",
    "description": "Refreshing mint flavor toothpaste",
    "price": 2.5,
    "imageUrl": "https://images.pexels.com/photos/6621497/pexels-photo-6621497.jpeg",
    "category": "Health & Personal Care",
    "stockQuantity": 100,
    "isAvailable": true,
    "rating": 4.6,
    "reviewCount": 95,
    "allergens": [],
    "relatedProducts": ["Toothbrush", "Mouthwash"],
    "suggestedProductId": null
  },

  // --- Household Supplies ---
  {
    "id": "prod_detergent_001",
    "name": "Laundry Detergent",
    "description": "Concentrated liquid detergent",
    "price": 6.0,
    "imageUrl": "https://images.pexels.com/photos/4791274/pexels-photo-4791274.jpeg",
    "category": "Household Supplies",
    "stockQuantity": 90,
    "isAvailable": true,
    "rating": 4.5,
    "reviewCount": 80,
    "allergens": [],
    "relatedProducts": ["Fabric Softener", "Bleach"],
    "suggestedProductId": null
  },

  // --- Baby & Child Care ---
  {
    "id": "prod_diapers_001",
    "name": "Baby Diapers",
    "description": "Soft and absorbent diapers",
    "price": 10.0,
    "imageUrl": "https://images.pexels.com/photos/1001897/pexels-photo-1001897.jpeg",
    "category": "Baby & Child Care",
    "stockQuantity": 80,
    "isAvailable": true,
    "rating": 4.8,
    "reviewCount": 140,
    "allergens": [],
    "relatedProducts": ["Baby Wipes", "Baby Lotion"],
    "suggestedProductId": null
  },

  // --- Pet Supplies ---
  {
    "id": "prod_dogfood_001",
    "name": "Dry Dog Food",
    "description": "Nutritious kibble for dogs",
    "price": 20.0,
    "imageUrl": "https://images.pexels.com/photos/4587998/pexels-photo-4587998.jpeg",
    "category": "Pet Supplies",
    "stockQuantity": 70,
    "isAvailable": true,
    "rating": 4.9,
    "reviewCount": 100,
    "allergens": [],
    "relatedProducts": ["Dog Treats", "Chew Toys"],
    "suggestedProductId": null
  }

];

Future<void> uploadInitialProducts() async {
  final collection = _firestore.collection('products');

  for (final product in initialProducts) {
    final docId = product['id'];
    final data = Map<String, dynamic>.from(product)..remove('id');

    try {
      final doc = await collection.doc(docId).get();
      if (!doc.exists) {
        await collection.doc(docId).set(data);
        print('✅ Uploaded: $docId');
      } else {
        print('ℹ️ Skipped (already exists): $docId');
      }
    } catch (e) {
      print('❌ Error uploading $docId: $e');
    }
  }
}