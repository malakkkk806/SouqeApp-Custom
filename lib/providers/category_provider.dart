import 'package:flutter/material.dart';
import '../models/category.dart';
import '../mock/explore_categories.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = exploreCategories;

  List<Category> get categories => _categories;

  void fetchCategories() {
    notifyListeners();
  }
}
