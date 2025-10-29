import 'package:groceryshopapp/models/product_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  int getItemQuantity(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(
          id: '', 
          name: '', 
          description: '', 
          price: 0, 
          imageUrl: '', 
          category: '', 
          unit: ''
        ), 
        quantity: 0
      ),
    );
    return item.quantity;
  }
}
