import 'package:flutter/foundation.dart';

/// Simple in-memory wishlist provider. Stores product IDs.
class WishlistProvider with ChangeNotifier {
  final Set<String> _wishlistedIds = {};

  List<String> get items => _wishlistedIds.toList(growable: false);

  bool isWishlisted(String productId) => _wishlistedIds.contains(productId);

  void add(String productId) {
    _wishlistedIds.add(productId);
    notifyListeners();
  }

  void remove(String productId) {
    _wishlistedIds.remove(productId);
    notifyListeners();
  }

  void toggle(String productId) {
    if (isWishlisted(productId)) {
      remove(productId);
    } else {
      add(productId);
    }
  }

  void clear() {
    _wishlistedIds.clear();
    notifyListeners();
  }
}
