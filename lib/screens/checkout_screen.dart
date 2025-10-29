import 'package:groceryshopapp/widgets/patment_method_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/providers/cart_provider.dart';
import 'package:groceryshopapp/widgets/address_card.dart';
import 'package:groceryshopapp/screens/order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with SingleTickerProviderStateMixin {
  int _selectedAddressIndex = 0;
  int _selectedPaymentMethod = 0;
  int _selectedDeliveryOption = 0;
  late AnimationController _animationController;
  bool _isPlacingOrder = false;

  final List<String> _deliveryOptions = ['Express (2hr)', 'Standard (4hr)', 'Next Day'];
  final List<String> _deliveryPrices = ['\$2.99', '\$1.99', 'Free'];

  final List<Map<String, dynamic>> _addresses = [
    {
      'name': 'Home',
      'address': '123 Main St, Apt 4B\nNew York, NY 10001',
      'isDefault': true,
      'type': Icons.home_rounded,
    },
    {
      'name': 'Work',
      'address': '456 Business Ave, Floor 12\nNew York, NY 10002',
      'isDefault': false,
      'type': Icons.work_rounded,
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'card',
      'name': 'Credit Card',
      'icon': Icons.credit_card_rounded,
      'lastFour': '4242',
      'color': AppTheme.primaryColor,
    },
    {
      'type': 'upi',
      'name': 'UPI',
      'icon': Icons.payment_rounded,
      'color': Colors.blue,
    },
    {
      'type': 'cod',
      'name': 'Cash on Delivery',
      'icon': Icons.money_rounded,
      'color': AppTheme.successColor,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    setState(() => _isPlacingOrder = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isPlacingOrder = false);
      _showOrderSuccess();
    }
  }

  void _showOrderSuccess() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 40,
                        color: AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Text(
                      'Order Placed Successfully!',
                      style: AppTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      'Your order has been confirmed and will be delivered soon.',
                      style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildOrderDetailRow('Order ID', '#ARM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),
                          _buildOrderDetailRow('Estimated Delivery', 'Tomorrow, 2:00 PM'),
                          _buildOrderDetailRow('Payment Method', _paymentMethods[_selectedPaymentMethod]['name']),
                          _buildOrderDetailRow('Total Amount', '\$${_calculateGrandTotal().toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                              cartProvider.clearCart();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppTheme.primaryColor),
                            ),
                            child: Text('Continue Shopping', style: AppTheme.button.copyWith(color: AppTheme.primaryColor)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                              cartProvider.clearCart();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('View Orders', style: AppTheme.button),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.caption),
          Text(value, style: AppTheme.bodyTextBold),
        ],
      ),
    );
  }

  double _calculateGrandTotal() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final total = cartProvider.totalPrice;
    final deliveryFee = _selectedDeliveryOption == 2 ? 0.0 : 
                       _selectedDeliveryOption == 1 ? 1.99 : 2.99;
    final tax = total * 0.08;
    return total + deliveryFee + tax;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
            _buildAppBar(),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      'Delivery Address',
                      'Change',
                      Icons.location_on_rounded,
                      _showAddressSelection,
                    ),
                    const SizedBox(height: 16),
                    AddressCard(
                      address: _addresses[_selectedAddressIndex],
                      isSelected: true,
                      onTap: _showAddressSelection,
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      'Delivery Time',
                      null,
                      Icons.access_time_rounded,
                      null,
                    ),
                    const SizedBox(height: 16),
                    _buildDeliveryOptions(),
                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      'Payment Method',
                      'Change',
                      Icons.payment_rounded,
                      _showPaymentMethodSelection,
                    ),
                    const SizedBox(height: 16),
                    PaymentMethodCard(
                      paymentMethod: _paymentMethods[_selectedPaymentMethod],
                      isSelected: true,
                      onTap: _showPaymentMethodSelection,
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      'Order Summary',
                      null,
                      Icons.receipt_rounded,
                      null,
                    ),
                    const SizedBox(height: 16),
                    _buildOrderSummary(cartProvider),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            _buildPlaceOrderButton(cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
            Text('Checkout', style: AppTheme.headline2),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText, IconData icon, VoidCallback? onAction) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: AppTheme.headline3),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText,
              style: AppTheme.captionBold.copyWith(color: AppTheme.primaryColor),
            ),
          ),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: _deliveryOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedDeliveryOption = index),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: index < _deliveryOptions.length - 1
                        ? BorderSide(color: Colors.grey[200]!)
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedDeliveryOption == index
                              ? AppTheme.primaryColor
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: _selectedDeliveryOption == index
                          ? Container(
                              margin: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(option, style: AppTheme.bodyTextBold),
                          Text(
                            _getDeliveryDescription(index),
                            style: AppTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _deliveryPrices[index],
                      style: AppTheme.bodyTextBold.copyWith(
                        color: _selectedDeliveryOption == index
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getDeliveryDescription(int index) {
    switch (index) {
      case 0: return 'Fastest delivery option';
      case 1: return 'Standard delivery time';
      case 2: return 'Free delivery for orders over \$50';
      default: return '';
    }
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    final total = cartProvider.totalPrice;
    final deliveryFee = _selectedDeliveryOption == 2 ? 0.0 : 
                       _selectedDeliveryOption == 1 ? 1.99 : 2.99;
    final tax = total * 0.08;
    final grandTotal = total + deliveryFee + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          ...cartProvider.cartItems.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.product.name} x${item.quantity}',
                    style: AppTheme.bodyText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: AppTheme.bodyTextBold,
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          _buildSummaryRow('Subtotal', total),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          _buildSummaryRow('Tax', tax),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildSummaryRow('Total', grandTotal, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  Widget _buildPlaceOrderButton(CartProvider cartProvider) {
    final grandTotal = _calculateGrandTotal();

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
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isPlacingOrder ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isPlacingOrder
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Place Order', style: AppTheme.button),
                          Text(
                            'Total: \$${grandTotal.toStringAsFixed(2)}',
                            style: AppTheme.smallText.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, size: 24),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _showAddressSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Address', style: AppTheme.headline2),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: _addresses.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _addresses.length) {
                            return Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _addNewAddress();
                                },
                                icon: const Icon(Icons.add_rounded),
                                label: const Text('Add New Address'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                  side: const BorderSide(color: AppTheme.primaryColor),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            );
                          }
                          return AddressCard(
                            address: _addresses[index],
                            isSelected: _selectedAddressIndex == index,
                            onTap: () {
                              setState(() => _selectedAddressIndex = index);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentMethodSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method', style: AppTheme.headline2),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              ..._paymentMethods.asMap().entries.map((entry) {
                final index = entry.key;
                final method = entry.value;
                return PaymentMethodCard(
                  paymentMethod: method,
                  isSelected: _selectedPaymentMethod == index,
                  onTap: () {
                    setState(() => _selectedPaymentMethod = index);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _addNewPaymentMethod();
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add New Payment Method'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _addNewAddress() {
    // Implement add new address functionality
  }

  void _addNewPaymentMethod() {
    // Implement add new payment method functionality
  }
}
