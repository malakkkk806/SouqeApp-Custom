import 'package:flutter/material.dart';

class Category {
  final String title;
  final String image;
  final Color bgColor;
  final String categoryId;

  Category({
    required this.title,
    required this.image,
    required this.bgColor,
    required this.categoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      image: json['image'],
      bgColor: Color(int.parse(json['bgColor'])),
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'bgColor': bgColor.value.toRadixString(16).padLeft(8, '0'),
        'categoryId': categoryId,
      };
}
