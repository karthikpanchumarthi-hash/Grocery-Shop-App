import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/models/product_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final bool isEditing;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.isEditing,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(cartItem.product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: AppTheme.bodyTextBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  cartItem.product.unit,
                  style: AppTheme.caption,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                  style: AppTheme.headline3.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          if (isEditing)
            IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              onPressed: onRemove,
            )
          else
            Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_rounded,
                      color: cartItem.quantity > 1 ? AppTheme.primaryColor : AppTheme.textLight,
                      size: 18,
                    ),
                    onPressed: cartItem.quantity > 1
                        ? () => onQuantityChanged(cartItem.quantity - 1)
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Center(
                      child: Text(
                        cartItem.quantity.toString(),
                        style: AppTheme.bodyTextBold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, color: AppTheme.primaryColor, size: 18),
                    onPressed: () => onQuantityChanged(cartItem.quantity + 1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
