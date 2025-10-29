import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';

class PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
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
          paymentMethod['icon'],
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
        ),
        title: Text(
          paymentMethod['name'],
          style: AppTheme.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          ),
        ),
        subtitle: paymentMethod['lastFour'] != null
            ? Text(
                '•••• ${paymentMethod['lastFour']}',
                style: AppTheme.caption.copyWith(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                ),
              )
            : null,
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
            : null,
      ),
    );
  }
}
