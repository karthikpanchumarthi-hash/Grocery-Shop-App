import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/providers/cart_provider.dart';
import 'package:groceryshopapp/widgets/cart_item_card.dart';
import 'package:groceryshopapp/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() => _isEditing = !_isEditing);
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart?', style: AppTheme.headline2),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: AppTheme.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTheme.bodyText),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All', style: AppTheme.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    if (cartItems.isEmpty) {
      return _buildEmptyCart();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _animationController,
            child: child,
          );
        },
        child: Column(
          children: [
            _buildAppBar(cartProvider),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    ...cartItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CartItemCard(
                          cartItem: item,
                          isEditing: _isEditing,
                          onRemove: () => cartProvider.removeFromCart(item.product.id),
                          onQuantityChanged: (newQuantity) {
                            cartProvider.updateQuantity(item.product.id, newQuantity);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    
                    _buildDeliveryInfo(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            _buildOrderSummary(cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
                iconSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shopping Cart', style: AppTheme.headline2),
                  Text(
                    '${cartProvider.totalItems} items',
                    style: AppTheme.caption,
                  ),
                ],
              ),
            ),
            if (cartProvider.cartItems.isNotEmpty) ...[
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.done_rounded : Icons.edit_rounded,
                  color: AppTheme.primaryColor,
                ),
                onPressed: _toggleEditMode,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.errorColor),
                onPressed: _clearCart,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_shipping_rounded, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Free Delivery', style: AppTheme.bodyTextBold),
                Text('On orders over \$50', style: AppTheme.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Eligible',
              style: AppTheme.smallText.copyWith(
                color: AppTheme.successColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    final total = cartProvider.totalPrice;
    final deliveryFee = total > 50 ? 0.0 : 2.99;
    final tax = total * 0.08;
    final grandTotal = total + deliveryFee + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildPriceRow('Subtotal', total),
            _buildPriceRow('Delivery Fee', deliveryFee),
            _buildPriceRow('Tax', tax),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildPriceRow('Total', grandTotal, isTotal: true),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Proceed to Checkout', style: AppTheme.button),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTheme.headline3
                : AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isTotal
                ? AppTheme.headline2.copyWith(color: AppTheme.primaryColor)
                : AppTheme.bodyTextBold,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildEmptyAppBar(),
            
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 60,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        'Your cart is empty',
                        style: AppTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      
                      Text(
                        'Looks like you haven\'t added anything to your cart yet',
                        style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context, 
                              '/home', 
                              (route) => false
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text('Start Shopping', style: AppTheme.button),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
                iconSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text('Shopping Cart', style: AppTheme.headline2),
          ],
        ),
      ),
    );
  }
}
