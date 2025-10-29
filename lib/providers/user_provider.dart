import 'package:flutter/foundation.dart';
import 'package:groceryshopapp/models/user_model.dart';
import 'package:groceryshopapp/models/address_model.dart';
import 'package:groceryshopapp/models/payment_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<Address> _addresses = [];
  List<PaymentMethod> _paymentMethods = [];

  User? get currentUser => _currentUser;
  List<Address> get addresses => _addresses;
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  Address? get defaultAddress => _addresses.firstWhere((addr) => addr.isDefault,
      orElse: () => _addresses.isNotEmpty
          ? _addresses.first
          : Address(
              id: '1',
              type: 'Home',
              name: 'Home',
              street: '123 Main St',
              city: 'New York',
              state: 'NY',
              zipCode: '10001',
              country: 'USA',
              isDefault: true,
            ));

  PaymentMethod? get defaultPaymentMethod =>
      _paymentMethods.firstWhere((pm) => pm.isDefault,
          orElse: () => _paymentMethods.isNotEmpty
              ? _paymentMethods.first
              : PaymentMethod(
                  id: '1',
                  type: 'card',
                  name: 'Credit Card',
                  cardNumber: '4242424242424242',
                  expiryDate: '12/25',
                  cvv: '123',
                  isDefault: true,
                ));

  // Initialize with sample data
  UserProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _currentUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 8900',
    );

    _addresses = [
      Address(
        id: '1',
        type: 'Home',
        name: 'Home',
        street: '123 Main Street',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        isDefault: true,
        phone: '+1 234 567 8900',
        instructions: 'Leave at front door',
      ),
      Address(
        id: '2',
        type: 'Work',
        name: 'Work',
        street: '456 Business Ave',
        city: 'New York',
        state: 'NY',
        zipCode: '10002',
        country: 'USA',
        isDefault: false,
        phone: '+1 234 567 8901',
      ),
    ];

    _paymentMethods = [
      PaymentMethod(
        id: '1',
        type: 'card',
        name: 'Credit Card',
        cardNumber: '4242424242424242',
        expiryDate: '12/25',
        cvv: '123',
        isDefault: true,
      ),
      PaymentMethod(
        id: '2',
        type: 'upi',
        name: 'UPI',
        upiId: 'john.doe@paytm',
        isDefault: false,
      ),
      PaymentMethod(
        id: '3',
        type: 'cod',
        name: 'Cash on Delivery',
        isDefault: false,
      ),
    ];
  }

  // User Management
  void updateUserProfile(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Address Management
  void addAddress(Address address) {
    // If this is the first address or user wants it as default, set as default
    if (_addresses.isEmpty || address.isDefault) {
      // Remove default from all other addresses
      for (var addr in _addresses) {
        addr = addr.copyWith(isDefault: false);
      }
    }
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(String addressId, Address updatedAddress) {
    final index = _addresses.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      // If setting as default, remove default from others
      if (updatedAddress.isDefault) {
        for (var i = 0; i < _addresses.length; i++) {
          if (_addresses[i].id != addressId) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }
      _addresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  void deleteAddress(String addressId) {
    _addresses.removeWhere((addr) => addr.id == addressId);
    // If we deleted the default address and there are other addresses, set the first one as default
    if (_addresses.isNotEmpty && !_addresses.any((addr) => addr.isDefault)) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  void setDefaultAddress(String addressId) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] =
          _addresses[i].copyWith(isDefault: _addresses[i].id == addressId);
    }
    notifyListeners();
  }

  // Payment Method Management
  void addPaymentMethod(PaymentMethod paymentMethod) {
    // If this is the first payment method or user wants it as default, set as default
    if (_paymentMethods.isEmpty || paymentMethod.isDefault) {
      // Remove default from all other payment methods
      for (var pm in _paymentMethods) {
        pm = pm.copyWith(isDefault: false);
      }
    }
    _paymentMethods.add(paymentMethod);
    notifyListeners();
  }

  void updatePaymentMethod(String paymentId, PaymentMethod updatedPayment) {
    final index = _paymentMethods.indexWhere((pm) => pm.id == paymentId);
    if (index != -1) {
      // If setting as default, remove default from others
      if (updatedPayment.isDefault) {
        for (var i = 0; i < _paymentMethods.length; i++) {
          if (_paymentMethods[i].id != paymentId) {
            _paymentMethods[i] = _paymentMethods[i].copyWith(isDefault: false);
          }
        }
      }
      _paymentMethods[index] = updatedPayment;
      notifyListeners();
    }
  }

  void deletePaymentMethod(String paymentId) {
    _paymentMethods.removeWhere((pm) => pm.id == paymentId);
    // If we deleted the default payment method and there are others, set the first one as default
    if (_paymentMethods.isNotEmpty &&
        !_paymentMethods.any((pm) => pm.isDefault)) {
      _paymentMethods[0] = _paymentMethods[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  void setDefaultPaymentMethod(String paymentId) {
    for (var i = 0; i < _paymentMethods.length; i++) {
      _paymentMethods[i] = _paymentMethods[i]
          .copyWith(isDefault: _paymentMethods[i].id == paymentId);
    }
    notifyListeners();
  }
}
