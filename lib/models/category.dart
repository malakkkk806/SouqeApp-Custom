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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      bgColor: Color(int.parse(json['bgColor'].toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'bgColor': '0x${bgColor.value.toRadixString(16).padLeft(8, '0')}',
      };
}
