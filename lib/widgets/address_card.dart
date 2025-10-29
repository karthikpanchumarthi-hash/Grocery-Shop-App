import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          address['type'] as IconData,
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
        ),
        title: Row(
          children: [
            Text(
              address['name'],
              style: AppTheme.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
            if (address['isDefault'] == true) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: AppTheme.smallText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          address['address'],
          style: AppTheme.caption.copyWith(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
            : null,
      ),
    );
  }
}
