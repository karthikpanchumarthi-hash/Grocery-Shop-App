import 'package:flutter/foundation.dart';
import 'package:groceryshopapp/models/product_model.dart';

class AuthProvider with ChangeNotifier {
  final List<dynamic> _orderHistory = [
    OrderData(
      id: '1234567890abcdef',
      items: [
        CartItem(
          id: '1',
          product: Product(
            id: '1',
            name: 'Organic Bananas',
            description: 'Fresh organic bananas',
            price: 2.99,
            imageUrl:
                'https://tse3.mm.bing.net/th/id/OIP.G0UWsHzuB2Pn3n7fzzN5iwHaHa?pid=Api&P=0&h=180',
            category: 'Fruits',
            rating: 4.5,
            reviewCount: 128,
            unit: '1 lb',
          ),
          quantity: 2,
        ),
      ],
      totalAmount: 5.98,
      status: 'Confirmed',
      paymentMethod: 'UPI',
      deliveryAddress: '123 Main St, City, State 12345',
      orderDate: DateTime.now().subtract(Duration(days: 5)),
    ),
    OrderData(
      id: '1234567890abcde1',
      items: [
        CartItem(
          id: '2',
          product: Product(
            id: '2',
            name: 'Fresh Avocado',
            description: 'Creamy Hass avocados',
            price: 1.99,
            imageUrl:
                'https://tse2.mm.bing.net/th/id/OIP.koIAEpg1y6uS3aT4jzkHZAHaGg?pid=Api&P=0&h=180',
            category: 'Fruits',
            rating: 4.2,
            reviewCount: 89,
            unit: 'each',
          ),
          quantity: 3,
        ),
      ],
      totalAmount: 5.97,
      status: 'Confirmed',
      paymentMethod: 'Card',
      deliveryAddress: '123 Main St, City, State 12345',
      orderDate: DateTime.now().subtract(Duration(days: 10)),
    ),
  ];

  List<dynamic> get orderHistory => _orderHistory;

  int get totalOrders => _orderHistory.length;

  double get totalSpent {
    return _orderHistory.fold(
        0, (sum, order) => sum + (order.totalAmount as double));
  }

  void addOrder(dynamic order) {
    _orderHistory.add(order);
    notifyListeners();
  }
}

class OrderData {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String deliveryAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  OrderData({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.orderDate,
    this.deliveryDate,
  });
}

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
}
