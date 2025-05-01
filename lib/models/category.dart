import 'package:flutter/material.dart';

class Category {
  final String title;
  final String image;
  final Color bgColor;

  Category({
    required this.title,
    required this.image,
    required this.bgColor,
  });

  // Optional: For parsing from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      image: json['image'],
      bgColor: Color(int.parse(json['bgColor'])), // Expects color as string like "0xFFE9F8E5"
    );
  }

  // Optional: For converting to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'bgColor': bgColor.value.toRadixString(16).padLeft(8, '0'), // Outputs color as hex
      };
}
