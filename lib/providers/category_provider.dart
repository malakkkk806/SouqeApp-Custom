import 'package:flutter/material.dart';
import '../models/category.dart';
import '../mock/explore_categories.dart';  // Import your category data

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = exploreCategories;

  List<Category> get categories => _categories;

  // You can replace this with API calls if you need to fetch categories from a server
  void fetchCategories() {
    // Simulate fetching categories
    notifyListeners();
  }
}
