import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider() {
    _init();
  }

  void _init() {
    _categoryService.getCategories().listen((data) {
      _categories = data;
      notifyListeners();
    });
  }
}
