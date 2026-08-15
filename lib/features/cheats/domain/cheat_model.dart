import 'package:flutter/material.dart';

class CheatModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final List<String> ps5Code;
  final List<String> xboxCode;
  final String pcCode;
  final bool isFavorite;

  const CheatModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.ps5Code,
    required this.xboxCode,
    required this.pcCode,
    this.isFavorite = false,
  });
}
