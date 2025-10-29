import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:groceryshopapp/providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed image container
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
              ),
            ),
            // Fixed content padding
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.unit,
                    style: AppTheme.caption.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTheme.headline3.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          if (product.isOnSale)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: AppTheme.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Consumer<WishlistProvider>(
                              builder: (context, wishlist, _) {
                            final isFav = wishlist.isWishlisted(product.id);
                            return GestureDetector(
                              onTap: () => wishlist.toggle(product.id),
                              child: Container(
                                width: 36,
                                height: 36,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: isFav
                                      ? AppTheme.errorColor
                                      : AppTheme.surfaceColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color:
                                      isFav ? Colors.white : AppTheme.textLight,
                                  size: 18,
                                ),
                              ),
                            );
                          }),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
