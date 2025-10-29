import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/screens/splash_screen.dart';
import 'package:groceryshopapp/screens/auth_screen.dart';
import 'package:groceryshopapp/screens/home_screen.dart';
import 'package:groceryshopapp/screens/product_detail_screen.dart';
import 'package:groceryshopapp/screens/cart_screen.dart';
import 'package:groceryshopapp/screens/checkout_screen.dart';
import 'package:groceryshopapp/screens/order_history_screen.dart';
import 'package:groceryshopapp/screens/profile_screen.dart';
import 'package:groceryshopapp/screens/search_screen.dart';
import 'package:groceryshopapp/screens/edit_profile_screen.dart';
import 'package:groceryshopapp/screens/address_management_screen.dart';
import 'package:groceryshopapp/screens/payment_management_screen.dart';
import 'package:groceryshopapp/screens/order_tracking_screen.dart';
import 'package:groceryshopapp/providers/cart_provider.dart';
import 'package:groceryshopapp/providers/product_provider.dart';
import 'package:groceryshopapp/providers/wishlist_provider.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/providers/order_provider.dart';

void main() {
  runApp(const ARMartApp());
}

class ARMartApp extends StatelessWidget {
  const ARMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'ARMart',
        theme: AppTheme.theme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/product-detail': (context) {
            final productId =
                ModalRoute.of(context)!.settings.arguments as String;
            return ProductDetailScreen(productId: productId);
          },
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order-history': (context) => const OrderHistoryScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/search': (context) => const SearchScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/address-management': (context) => const AddressManagementScreen(),
          '/payment-management': (context) => const PaymentManagementScreen(),
          '/order-tracking': (context) {
            final orderId =
                ModalRoute.of(context)!.settings.arguments as String;
            return OrderTrackingScreen(orderId: orderId);
          },
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
