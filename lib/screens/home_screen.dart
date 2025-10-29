import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/models/category_model.dart';
import 'package:groceryshopapp/providers/cart_provider.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/providers/product_provider.dart';
import 'package:groceryshopapp/widgets/category_card.dart';
import 'package:groceryshopapp/widgets/product_card.dart';
import 'package:groceryshopapp/widgets/search_bar.dart';
import 'package:groceryshopapp/screens/cart_screen.dart';
import 'package:groceryshopapp/screens/profile_screen.dart';
import 'package:groceryshopapp/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  final List<Category> _categories = [
    Category(id: '1', name: 'Fruits', icon: '🍎', color: Colors.red[100]!),
    Category(
        id: '2', name: 'Vegetables', icon: '🥦', color: Colors.green[100]!),
    Category(id: '3', name: 'Dairy', icon: '🥛', color: Colors.blue[100]!),
    Category(id: '4', name: 'Meat', icon: '🍗', color: Colors.orange[100]!),
    Category(id: '5', name: 'Bakery', icon: '🍞', color: Colors.brown[100]!),
    Category(
        id: '6', name: 'Beverages', icon: '🥤', color: Colors.purple[100]!),
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_bannerController.hasClients && mounted) {
        if (_currentBanner < 2) {
          _bannerController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _bannerController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startBannerAutoScroll();
      }
    });
  }

  void _showARFeature() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AR feature would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(cartProvider),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomSearchBar(),
                    ),
                    const SizedBox(height: 24),
                    _buildBannerCarousel(),
                    const SizedBox(height: 32),
                    _buildCategoriesSection(),
                    const SizedBox(height: 32),
                    _buildPopularProducts(productProvider),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(cartProvider),
    );
  }

  Widget _buildAppBar(CartProvider cartProvider) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.currentUser?.name ?? 'Guest';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppTheme.surfaceColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, 👋',
                style: AppTheme.caption.copyWith(color: AppTheme.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: AppTheme.headline2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final banners = [
      {
        'title': '20% OFF',
        'subtitle': 'on Fresh Fruits',
        'color': AppTheme.primaryColor,
        'image': '🎁',
      },
      {
        'title': 'Free Delivery',
        'subtitle': 'on orders over \$50',
        'color': AppTheme.secondaryColor,
        'image': '🚚',
      },
      {
        'title': 'New Arrivals',
        'subtitle': 'Check out latest products',
        'color': AppTheme.infoColor,
        'image': '🆕',
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentBanner = index),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      banner['color'] as Color,
                      (banner['color'] as Color).withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: AppTheme.headline1.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['subtitle'] as String,
                            style: AppTheme.bodyText.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Shop Now',
                              style: AppTheme.captionBold.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 0,
                      child: Text(
                        banner['image'] as String,
                        style: const TextStyle(fontSize: 70),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBanner == index
                    ? AppTheme.primaryColor
                    : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories',
                  style: AppTheme.headline2.copyWith(fontSize: 20)),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTheme.captionBold
                      .copyWith(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: _categories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularProducts(ProductProvider productProvider) {
    final popularProducts = productProvider.featuredProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Products',
                  style: AppTheme.headline2.copyWith(fontSize: 20)),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTheme.captionBold
                      .copyWith(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: popularProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(product: popularProducts[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(CartProvider cartProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', true, () {}),
              _buildNavItem(Icons.search_rounded, 'Search', false, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()));
              }),
              _buildNavItem(
                  Icons.camera_alt_rounded, 'AR', false, _showARFeature),
              _buildNavItemWithBadge(
                Icons.shopping_cart_rounded,
                'Cart',
                false,
                cartProvider.totalItems,
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen()));
                },
              ),
              _buildNavItem(Icons.person_rounded, 'Profile', false, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.smallText.copyWith(
              color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemWithBadge(IconData icon, String label, bool isActive,
      int badgeCount, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
                  size: 18,
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount > 9 ? '9+' : badgeCount.toString(),
                      style: AppTheme.smallText.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.smallText.copyWith(
              color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
