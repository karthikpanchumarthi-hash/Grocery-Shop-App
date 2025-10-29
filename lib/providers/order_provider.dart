import 'package:flutter/foundation.dart';
import 'package:groceryshopapp/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  List<Order> get pendingOrders =>
      _orders.where((order) => order.status == 'pending').toList();
  List<Order> get confirmedOrders =>
      _orders.where((order) => order.status == 'confirmed').toList();
  List<Order> get processingOrders =>
      _orders.where((order) => order.status == 'processing').toList();
  List<Order> get shippedOrders =>
      _orders.where((order) => order.status == 'shipped').toList();
  List<Order> get deliveredOrders =>
      _orders.where((order) => order.status == 'delivered').toList();
  List<Order> get cancelledOrders =>
      _orders.where((order) => order.status == 'cancelled').toList();

  // Initialize with sample orders
  OrderProvider() {
    _initializeSampleOrders();
  }

  void _initializeSampleOrders() {
    // Sample orders would be initialized here
    // This is just placeholder - in real app, you'd load from API
  }

  void placeOrder(Order order) {
    _orders.insert(0, order); // Add to beginning for latest first
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final old = _orders[index];
      final updated = Order(
        id: old.id,
        userId: old.userId,
        items: old.items,
        subtotal: old.subtotal,
        deliveryFee: old.deliveryFee,
        tax: old.tax,
        total: old.total,
        status: newStatus,
        orderDate: old.orderDate,
        deliveryDate: old.deliveryDate,
        deliveryAddress: old.deliveryAddress,
        paymentMethod: old.paymentMethod,
        trackingNumber: old.trackingNumber,
        deliveryNotes: old.deliveryNotes,
      );
      _orders[index] = updated;
      notifyListeners();
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, 'cancelled');
  }

  // Track order - returns tracking information
  Map<String, dynamic> trackOrder(String orderId) {
    final order = getOrderById(orderId);
    if (order == null) {
      return {'error': 'Order not found'};
    }

    // Simulate tracking information based on order status
    final trackingInfo = {
      'orderId': orderId,
      'status': order.status,
      'estimatedDelivery': order.deliveryDate?.toIso8601String(),
      'trackingNumber': order.trackingNumber ?? 'Not available',
      'updates': _generateTrackingUpdates(order),
    };

    return trackingInfo;
  }

  List<Map<String, dynamic>> _generateTrackingUpdates(Order order) {
    final updates = [
      {
        'status': 'Order Placed',
        'date': order.orderDate,
        'description': 'Your order has been placed successfully',
        'completed': true,
      },
    ];

    // Add status-based updates
    if (order.status == 'confirmed' ||
        order.status == 'processing' ||
        order.status == 'shipped' ||
        order.status == 'delivered') {
      updates.add({
        'status': 'Order Confirmed',
        'date': order.orderDate.add(const Duration(hours: 1)),
        'description': 'Your order has been confirmed',
        'completed': true,
      });
    }

    if (order.status == 'processing' ||
        order.status == 'shipped' ||
        order.status == 'delivered') {
      updates.add({
        'status': 'Processing',
        'date': order.orderDate.add(const Duration(hours: 2)),
        'description': 'Your items are being prepared',
        'completed': true,
      });
    }

    if (order.status == 'shipped' || order.status == 'delivered') {
      updates.add({
        'status': 'Shipped',
        'date': order.orderDate.add(const Duration(days: 1)),
        'description': 'Your order has been shipped',
        'completed': true,
      });
    }

    if (order.status == 'delivered') {
      updates.add({
        'status': 'Delivered',
        'date': order.deliveryDate!,
        'description': 'Your order has been delivered',
        'completed': true,
      });
    }

    // Add current status as pending if not completed
    if (order.status != 'delivered' && order.status != 'cancelled') {
      String currentStatus = '';
      String description = '';

      switch (order.status) {
        case 'pending':
          currentStatus = 'Pending';
          description = 'Waiting for confirmation';
          break;
        case 'confirmed':
          currentStatus = 'Confirmed';
          description = 'Order is being processed';
          break;
        case 'processing':
          currentStatus = 'Processing';
          description = 'Items are being prepared';
          break;
        case 'shipped':
          currentStatus = 'Shipped';
          description = 'Out for delivery';
          break;
      }

      updates.add({
        'status': currentStatus,
        'date': DateTime.now(),
        'description': description,
        'completed': false,
      });
    }

    return updates;
  }
}
