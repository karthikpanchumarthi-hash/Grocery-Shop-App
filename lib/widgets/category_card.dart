import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: AppTheme.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
