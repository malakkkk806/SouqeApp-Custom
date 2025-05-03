import '/models/product.dart'; 

class FruitsAndVegetables {
  static List<Product> getProducts() {
    return [
      Product(
        id: "prod_banana_001",
        name: "Bananas",
        description: "Fresh organic bananas",
        price: 1.2,
        imageUrl: 'assets/images/banana.png',
        category: "Fruits & Vegetables",
        stockQuantity: 150,
        isAvailable: true,
        rating: 4.7,
        reviewCount: 200,
        allergens: [],
        relatedProducts: ["Peanut Butter", "Yogurt"],
        suggestedProductId: "prod_yogurt_001", 
        relatedProduct: [], categoryId: '1',
      ),
      Product(
        id: "prod_carrot_001",
        name: "Carrots",
        description: "Crunchy organic carrots",
        price: 0.9,
        imageUrl: "https://images.pexels.com/photos/65174/pexels-photo-65174.jpeg",
        category: "Fruits & Vegetables",
        stockQuantity: 120,
        isAvailable: true,
        rating: 4.5,
        reviewCount: 150,
        allergens: [],
        relatedProducts: ["Hummus", "Celery"],
        suggestedProductId: null, relatedProduct: [], categoryId: '1',
      ),
      // Add more products...
    ];
  }
}

class MeatAndSeafood {
  static List<Product> getProducts() {
    return [
      Product(
        id: "prod_chicken_001",
        name: "Broiler Chicken",
        description: "Fresh and tender broiler chicken meat",
        price: 8.5,
        imageUrl: "https://images.pexels.com/photos/65175/pexels-photo-65175.jpeg",
        category: "Meat & Seafood",
        stockQuantity: 100,
        isAvailable: true,
        rating: 4.6,
        reviewCount: 180,
        allergens: ["Meat"],
        relatedProducts: ["Garlic", "Lemon", "Rosemary"],
        suggestedProductId: "prod_cheese_001", relatedProduct: [], categoryId: '',
      ),
      Product(
        id: "prod_salmon_001",
        name: "Salmon Fillet",
        description: "Fresh Atlantic salmon fillet",
        price: 12.0,
        imageUrl: "https://images.pexels.com/photos/65175/pexels-photo-65175.jpeg",
        category: "Meat & Seafood",
        stockQuantity: 80,
        isAvailable: true,
        rating: 4.8,
        reviewCount: 90,
        allergens: ["Fish"],
        relatedProducts: ["Lemon", "Dill"],
        suggestedProductId: null, relatedProduct: [], categoryId: '',
      ),
      // Add more products...
    ];
  }
}

class DairyAndEggs {
  static List<Product> getProducts() {
    return [
      Product(
        id: "prod_milk_001",
        name: "Whole Milk",
        description: "Fresh whole milk",
        price: 2.5,
        imageUrl: "https://images.pexels.com/photos/416656/pexels-photo-416656.jpeg",
        category: "Dairy & Eggs",
        stockQuantity: 200,
        isAvailable: true,
        rating: 4.7,
        reviewCount: 180,
        allergens: ["Dairy"],
        relatedProducts: ["Cereal", "Cookies"],
        suggestedProductId: null, relatedProduct: [], categoryId: '',
      ),
      Product(
        id: "prod_eggs_001",
        name: "Eggs (Dozen)",
        description: "Free-range eggs",
        price: 3.0,
        imageUrl: "https://images.pexels.com/photos/162712/eggs-egg-carton-chicken-eggs-162712.jpeg",
        category: "Dairy & Eggs",
        stockQuantity: 180,
        isAvailable: true,
        rating: 4.8,
        reviewCount: 160,
        allergens: ["Eggs"],
        relatedProducts: ["Bacon", "Toast"],
        suggestedProductId: null, relatedProduct: [], categoryId: '',
      ),
      // Add more products...
    ];
  }
}
class CondimentsAndSpices {
  static List<Product> getProducts() {
    return [
      Product(
        id: "prod_pepper_001",
        name: "Pepper",
        description: "1kg, Priceg",
        price: 4.99,
        imageUrl: "https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg",
        category: "Condiments & Spices",
        stockQuantity: 60,
        isAvailable: true,
        rating: 4.5,
        reviewCount: 95,
        allergens: [],
        relatedProducts: ["Ginger"],
        suggestedProductId: null,
        relatedProduct: [], categoryId: '',
      ),
      Product(
        id: "prod_ginger_001",
        name: "Ginger",
        description: "0.5kg, Priceg",
        price: 4.99,
        imageUrl: "https://images.pexels.com/photos/41140/ginger-root-healthy-vegetables-41140.jpeg",
        category: "Condiments & Spices",
        stockQuantity: 70,
        isAvailable: true,
        rating: 4.5,
        reviewCount: 90,
        allergens: [],
        relatedProducts: ["Pepper"],
        suggestedProductId: null,
        relatedProduct: [], categoryId: '',
      ),
    ];
  }
}
class PantryStaples {
  static List<Product> getProducts() {
    return [
      Product(
        id: "prod_pulses_001",
        name: "Pulses",
        description: "1kg, Priceg",
        price: 3.99,
        imageUrl: "https://images.pexels.com/photos/41125/lentil-pulses-pile-eat-41125.jpeg",
        category: "Pantry Staples",
        stockQuantity: 50,
        isAvailable: true,
        rating: 4.5,
        reviewCount: 100,
        allergens: [],
        relatedProducts: ["Rice"],
        suggestedProductId: null,
        relatedProduct: [], categoryId: '',
      ),
      Product(
        id: "prod_rice_001",
        name: "Basmati Rice",
        description: "Long grain basmati rice",
        price: 2.0,
        imageUrl: "https://images.pexels.com/photos/4198023/pexels-photo-4198023.jpeg",
        category: "Pantry Staples",
        stockQuantity: 130,
        isAvailable: true,
        rating: 4.6,
        reviewCount: 110,
        allergens: [],
        relatedProducts: ["Curry Powder", "Lentils"],
        suggestedProductId: null,
        relatedProduct: [], categoryId: '',
      ),
    ];
  }
}

final List<Product> allProducts = [
  ...FruitsAndVegetables.getProducts(),
  ...MeatAndSeafood.getProducts(),
  ...DairyAndEggs.getProducts(),
];