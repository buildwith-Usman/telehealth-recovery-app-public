import 'package:flutter/material.dart';

class SpecialistItem {
  final String name;
  final String profession;
  final String credentials;
  final String experience;
  final double rating;
  final String? imageUrl;
  final VoidCallback? onTap;

  const SpecialistItem({
    required this.name,
    required this.profession,
    required this.credentials,
    required this.experience,
    required this.rating,
    this.imageUrl,
    this.onTap,
  });
}
