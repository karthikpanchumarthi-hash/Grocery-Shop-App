
import 'package:flutter/material.dart';
import 'package:groceryshopapp/models/product_model.dart';

enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

enum PaymentMethod { upi, cod, card, wallet }

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final Address deliveryAddress;
  final PaymentMethod paymentMethod;
  final String? trackingNumber;
  final String? deliveryNotes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.trackingNumber,
    this.deliveryNotes,
  });

  String get formattedOrderDate {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
  }

  String get formattedDeliveryDate {
    if (deliveryDate == null) return 'Not scheduled';
    return '${deliveryDate!.day}/${deliveryDate!.month}/${deliveryDate!.year}';
  }

  String get orderStatusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class Address {
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state - $pincode';
}

class PaymentMethodModel {
  final String id;
  final PaymentMethod type;
  final String displayName;
  final String? lastFourDigits;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.displayName,
    this.lastFourDigits,
    this.isDefault = false,
  });
}