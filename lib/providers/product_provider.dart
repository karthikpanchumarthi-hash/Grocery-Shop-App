import 'package:groceryshopapp/models/product_model.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Organic Bananas',
      description: 'Fresh organic bananas rich in potassium and other essential nutrients. Perfect for smoothies, baking, or as a healthy snack.',
      price: 2.99,
      originalPrice: 3.49,
      imageUrl: 'https://tse3.mm.bing.net/th/id/OIP.G0UWsHzuB2Pn3n7fzzN5iwHaHa?pid=Api&P=0&h=180',
      category: 'Fruits',
      rating: 4.5,
      reviewCount: 128,
      unit: '1 lb',
    ),
    Product(
      id: '2',
      name: 'Fresh Avocado',
      description: 'Creamy Hass avocados, perfect for guacamole, toast, or salads. Rich in healthy fats and fiber.',
      price: 1.99,
      imageUrl: 'https://tse2.mm.bing.net/th/id/OIP.koIAEpg1y6uS3aT4jzkHZAHaGg?pid=Api&P=0&h=180',
      category: 'Fruits',
      rating: 4.2,
      reviewCount: 89,
      unit: 'each',
    ),
    Product(
      id: '3',
      name: 'Organic Strawberries',
      description: 'Sweet and juicy organic strawberries. Packed with vitamins and antioxidants.',
      price: 4.99,
      originalPrice: 5.99,
      imageUrl: 'https://tse1.mm.bing.net/th/id/OIP.HB4HZm81d40h5Ng8eb4HnwHaHa?pid=Api&P=0&h=180',
      category: 'Fruits',
      rating: 4.7,
      reviewCount: 203,
      unit: '1 lb',
    ),
    Product(
      id: '4',
      name: 'Broccoli',
      description: 'Fresh green broccoli, perfect for steaming, roasting, or stir-fries.',
      price: 2.49,
      imageUrl: 'https://tse2.mm.bing.net/th/id/OIP.M2W6eb6piZekqvm1ODYSfQHaHa?pid=Api&P=0&h=180',
      category: 'Vegetables',
      rating: 4.3,
      reviewCount: 67,
      unit: '1 lb',
    ),
    Product(
      id: '5',
      name: 'Organic Milk',
      description: 'Fresh organic whole milk from grass-fed cows.',
      price: 4.99,
      imageUrl: 'https://tse4.mm.bing.net/th/id/OIP.VZWznt9C4xxHOLWUykjK5AHaEB?pid=Api&P=0&h=180',
      category: 'Dairy',
      rating: 4.6,
      reviewCount: 156,
      unit: '1 gallon',
    ),
    Product(
      id: '6',
      name: 'Whole Wheat Bread',
      description: 'Freshly baked whole wheat bread with no preservatives.',
      price: 3.49,
      imageUrl: 'https://tse1.mm.bing.net/th/id/OIP.Eh9o6rAyOt6MpDN-1iwdnQHaEJ?pid=Api&P=0&h=180',
      category: 'Bakery',
      rating: 4.4,
      reviewCount: 89,
      unit: 'loaf',
    ),
  ];

  List<Product> get products => _products;
  
  List<Product> get featuredProducts => _products.where((product) => product.rating >= 4.0).toList();
  
  List<String> get categories {
    return _products.map((product) => product.category).toSet().toList();
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Product getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}
