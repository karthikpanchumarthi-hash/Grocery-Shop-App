import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onSearchChanged;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    this.onFilterPressed,
    this.onSearchChanged,
    this.hintText = 'Search for groceries...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTheme.caption,
                  border: InputBorder.none,
                  icon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                ),
                style: AppTheme.bodyText,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey[200],
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: AppTheme.primaryColor),
            onPressed: onFilterPressed,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
