import 'package:flutter/material.dart';
import 'package:groceryshopapp/models/order_model.dart';
import 'package:groceryshopapp/providers/order_provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(widget.orderId);
    final trackingInfo =
        order != null ? orderProvider.trackOrder(widget.orderId) : null;

    if (order == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Order Tracking'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 20),
              Text(
                'Order Not Found',
                style: AppTheme.headline2,
              ),
              const SizedBox(height: 10),
              Text(
                'The order you are looking for does not exist',
                style:
                    AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Order Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            _buildOrderSummary(order),
            const SizedBox(height: 24),

            // Tracking Timeline
            _buildTrackingTimeline(trackingInfo!),
            const SizedBox(height: 24),

            // Order Details
            _buildOrderDetails(order),
            const SizedBox(height: 24),

            // Delivery Information
            _buildDeliveryInfo(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order.id}', style: AppTheme.headline3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.orderStatusText,
                  style: AppTheme.smallText.copyWith(
                    color: order.statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Placed on ${order.formattedOrderDate}',
                style: AppTheme.caption,
              ),
            ],
          ),
          if (order.deliveryDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.local_shipping_rounded,
                    size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Expected delivery: ${order.formattedDeliveryDate}',
                  style: AppTheme.caption,
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: AppTheme.bodyTextBold),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style:
                    AppTheme.headline3.copyWith(color: AppTheme.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(Map<String, dynamic> trackingInfo) {
    final updates = trackingInfo['updates'] as List<Map<String, dynamic>>;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Status', style: AppTheme.headline3),
          const SizedBox(height: 16),
          ...updates.asMap().entries.map((entry) {
            final index = entry.key;
            final update = entry.value;
            final isLast = index == updates.length - 1;

            return _buildTimelineStep(
              status: update['status'],
              description: update['description'],
              date: update['date'],
              completed: update['completed'],
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String status,
    required String description,
    required DateTime date,
    required bool completed,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and dot
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: completed ? AppTheme.successColor : AppTheme.textLight,
                shape: BoxShape.circle,
              ),
              child: completed
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: completed
                    ? AppTheme.successColor
                    : AppTheme.textLight.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: AppTheme.bodyTextBold.copyWith(
                    color:
                        completed ? AppTheme.textPrimary : AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.caption.copyWith(
                    color:
                        completed ? AppTheme.textSecondary : AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(date),
                  style: AppTheme.smallText.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _paymentMethodToString(dynamic pm) {
    // pm is the enum PaymentMethod from models/order_model.dart
    switch (pm) {
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
      case PaymentMethod.wallet:
        return 'Wallet';
      default:
        return 'Unknown';
    }
  }

  Widget _buildOrderDetails(Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items', style: AppTheme.headline3),
          const SizedBox(height: 16),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_bag_rounded,
                        size: 20, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name, style: AppTheme.bodyText),
                        Text('Qty: ${item.quantity}', style: AppTheme.caption),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: AppTheme.bodyTextBold,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildPriceRow('Subtotal', order.subtotal),
          _buildPriceRow('Delivery Fee', order.deliveryFee),
          _buildPriceRow('Tax', order.tax),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildPriceRow('Total', order.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(Order order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Information', style: AppTheme.headline3),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_rounded,
                  size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Address', style: AppTheme.bodyTextBold),
                    const SizedBox(height: 4),
                    Text(order.deliveryAddress.fullAddress,
                        style: AppTheme.caption),
                    ...[
                      const SizedBox(height: 4),
                      Text('Phone: ${order.deliveryAddress.phone}',
                          style: AppTheme.caption),
                    ],
                    if (order.deliveryNotes != null) ...[
                      const SizedBox(height: 4),
                      Text('Notes: ${order.deliveryNotes}',
                          style: AppTheme.caption),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.payment_rounded,
                  size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Method', style: AppTheme.bodyTextBold),
                    const SizedBox(height: 4),
                    Text(order.paymentMethod.name, style: AppTheme.caption),
                    const SizedBox(height: 4),
                    Text(_paymentMethodToString(order.paymentMethod),
                        style: AppTheme.caption),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                ? AppTheme.bodyTextBold
                : AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isTotal
                ? AppTheme.headline3.copyWith(color: AppTheme.primaryColor)
                : AppTheme.bodyTextBold,
          ),
        ],
      ),
    );
  }
}
