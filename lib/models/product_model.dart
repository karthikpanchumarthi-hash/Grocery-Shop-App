class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.unit,
  });

  bool get isOnSale => originalPrice != null && originalPrice! > price;
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
