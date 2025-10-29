import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/providers/cart_provider.dart';
import 'package:groceryshopapp/providers/product_provider.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  int _quantity = 1;
  int _selectedTabIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;
  bool _showARView = false;

  // Sample product images
  final List<String> _productImages = [
    'https://images.unsplash.com/photo-1587132137056-bfbf0166836e?w=500&h=500&fit=crop',
    'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500&h=500&fit=crop',
    'https://images.unsplash.com/photo-1603833665858-e61d17a86224?w=500&h=500&fit=crop',
  ];

  // Sample reviews
  final List<Map<String, dynamic>> _reviews = [
    {
      'id': '1',
      'userName': 'Sarah Johnson',
      'userAvatar': 'S',
      'rating': 5,
      'date': '2 days ago',
      'comment':
          'Absolutely love these bananas! Perfect ripeness and great taste. Will definitely order again.',
      'helpful': 12,
    },
    {
      'id': '2',
      'userName': 'Mike Chen',
      'userAvatar': 'M',
      'rating': 4,
      'date': '1 week ago',
      'comment':
          'Good quality overall, but some pieces were smaller than expected. Still satisfied with the purchase.',
      'helpful': 8,
    },
    {
      'id': '3',
      'userName': 'Emily Davis',
      'userAvatar': 'E',
      'rating': 5,
      'date': '2 weeks ago',
      'comment':
          'Best quality bananas I have found online. Sweet and fresh. Perfect for smoothies!',
      'helpful': 15,
    },
    {
      'id': '4',
      'userName': 'Alex Thompson',
      'userAvatar': 'A',
      'rating': 3,
      'date': '3 weeks ago',
      'comment':
          'Average quality. Some bananas were too green, had to wait for them to ripen.',
      'helpful': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showARPreview() {
    setState(() => _showARView = true);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.camera_alt_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Text('AR Preview', style: AppTheme.headline3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_rounded,
                      size: 50, color: AppTheme.primaryColor),
                  const SizedBox(height: 16),
                  Text('AR Camera View', style: AppTheme.bodyTextBold),
                  const SizedBox(height: 8),
                  Text(
                    'Point your camera at a flat surface to view this product in your space',
                    style: AppTheme.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Feature Coming Soon!',
              style:
                  AppTheme.bodyTextBold.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              'AR functionality will be available in the next update',
              style: AppTheme.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: AppTheme.bodyText),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would open the AR camera
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Try Demo', style: AppTheme.button),
          ),
        ],
      ),
    );

    // Auto-close AR view after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showARView = false);
    });
  }

  void _showAddToCartSuccess(String productName, int quantity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.successColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added $quantity× $productName to cart',
                style: AppTheme.bodyText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  void _shareProduct(Product product) {
    // Simulate share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.share_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text('Sharing ${product.name}...',
                style: AppTheme.bodyText.copyWith(color: Colors.white)),
          ],
        ),
        backgroundColor: AppTheme.infoColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double _calculateAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    final totalRating = _reviews.fold(
        0.0, (sum, review) => sum + (review['rating'] as int).toDouble());
    return totalRating / _reviews.length;
  }

  Map<int, int> _calculateRatingDistribution() {
    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in _reviews) {
      final rating = review['rating'] as int;
      distribution[rating] = distribution[rating]! + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final product = productProvider.getProductById(widget.productId);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(context, product),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel with AR Button
                    _buildImageCarousel(product),
                    const SizedBox(height: 24),

                    // Product Basic Info
                    _buildProductInfo(product),
                    const SizedBox(height: 24),

                    // Quantity Selector
                    _buildQuantitySelector(),
                    const SizedBox(height: 32),

                    // Product Details Tabs
                    _buildProductTabs(product),
                    const SizedBox(height: 100), // Space for bottom buttons
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            _buildBottomActionBar(product, cartProvider, userProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Spacer(),

            // Product Name (truncated)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  product.name,
                  style: AppTheme.headline3,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Spacer(),

            // Favorite Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: _isFavorite ? AppTheme.errorColor : AppTheme.textLight,
                  size: 20,
                ),
                onPressed: _toggleFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(Product product) {
    return Stack(
      children: [
        Column(
          children: [
            // Image Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 280,
                viewportFraction: 0.85,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() => _currentImageIndex = index);
                },
              ),
              items: _productImages.map((imageUrl) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: AppTheme.cardShadow,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Image Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _productImages.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentImageIndex == entry.key ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key
                        ? AppTheme.primaryColor
                        : Colors.grey[300],
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // AR Button
        Positioned(
          bottom: 30,
          right: 30,
          child: FloatingActionButton(
            onPressed: _showARPreview,
            backgroundColor: AppTheme.surfaceColor,
            foregroundColor: AppTheme.primaryColor,
            elevation: 4,
            child: const Icon(Icons.camera_alt_rounded, size: 24),
          ),
        ),

        // Sale Badge
        if (product.isOnSale)
          Positioned(
            top: 20,
            left: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.secondaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'SALE',
                style: AppTheme.captionBold.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo(Product product) {
    final averageRating = _calculateAverageRating();
    final totalReviews = _reviews.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name and Share Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTheme.headline1.copyWith(fontSize: 24),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => _shareProduct(product),
                icon: Icon(Icons.share_rounded, color: AppTheme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rating and Reviews
          Row(
            children: [
              // Star Rating
              _buildRatingStars(averageRating),
              const SizedBox(width: 8),

              // Rating Number
              Text(
                averageRating.toStringAsFixed(1),
                style: AppTheme.bodyTextBold,
              ),
              const SizedBox(width: 4),

              // Review Count
              Text(
                '($totalReviews reviews)',
                style: AppTheme.caption,
              ),
              const SizedBox(width: 16),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  product.category,
                  style: AppTheme.smallText.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Section
          _buildPriceSection(product),
          const SizedBox(height: 16),

          // Description
          Text(
            product.description,
            style: AppTheme.bodyText.copyWith(
              height: 1.6,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Additional Info Chips
          _buildInfoChips(product),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star_rounded
              : (index < rating.ceil()
                  ? Icons.star_half_rounded
                  : Icons.star_border_rounded),
          color: AppTheme.secondaryColor,
          size: 20,
        );
      }),
    );
  }

  Widget _buildPriceSection(Product product) {
    return Row(
      children: [
        // Current Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: AppTheme.headline1.copyWith(
            fontSize: 28,
            color: AppTheme.primaryColor,
          ),
        ),

        // Original Price and Discount (if on sale)
        if (product.isOnSale) ...[
          const SizedBox(width: 12),
          Text(
            '\$${product.originalPrice!.toStringAsFixed(2)}',
            style: AppTheme.headline3.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'SAVE \$${(product.originalPrice! - product.price).toStringAsFixed(2)}',
              style: AppTheme.smallText.copyWith(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],

        const Spacer(),

        // Unit Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            product.unit,
            style: AppTheme.captionBold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChips(Product product) {
    final chips = [
      {
        'icon': Icons.eco_rounded,
        'text': 'Organic',
        'color': AppTheme.successColor
      },
      {'icon': Icons.favorite_rounded, 'text': 'Healthy', 'color': Colors.red},
      {
        'icon': Icons.local_shipping_rounded,
        'text': 'Free Delivery',
        'color': AppTheme.infoColor
      },
      {
        'icon': Icons.assistant_rounded,
        'text': 'AR Preview',
        'color': AppTheme.primaryColor
      },
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((chip) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (chip['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: (chip['color'] as Color).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(chip['icon'] as IconData,
                  size: 14, color: chip['color'] as Color),
              const SizedBox(width: 4),
              Text(
                chip['text'] as String,
                style: AppTheme.smallText.copyWith(
                  color: chip['color'] as Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text('Quantity:', style: AppTheme.headline3),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                // Decrease Button
                IconButton(
                  icon: Icon(
                    Icons.remove_rounded,
                    color: _quantity > 1
                        ? AppTheme.primaryColor
                        : AppTheme.textLight,
                    size: 20,
                  ),
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() => _quantity--);
                    }
                  },
                ),

                // Quantity Display
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      _quantity.toString(),
                      style: AppTheme.headline3,
                    ),
                  ),
                ),

                // Increase Button
                IconButton(
                  icon: Icon(Icons.add_rounded,
                      color: AppTheme.primaryColor, size: 20),
                  onPressed: () {
                    setState(() => _quantity++);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTabs(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Tab Headers
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: ['Details', 'Nutrition', 'Reviews']
                  .asMap()
                  .entries
                  .map((entry) {
                final isSelected = _selectedTabIndex == entry.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyTextBold.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Tab Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedTabIndex == 0
                ? _buildDetailsTab(product)
                : _selectedTabIndex == 1
                    ? _buildNutritionTab()
                    : _buildReviewsTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(Product product) {
    final details = [
      {
        'icon': Icons.category_rounded,
        'title': 'Category',
        'value': product.category
      },
      {'icon': Icons.scale_rounded, 'title': 'Weight', 'value': product.unit},
      {
        'icon': Icons.place_rounded,
        'title': 'Origin',
        'value': 'Organic Farm, California'
      },
      {
        'icon': Icons.agriculture_rounded,
        'title': 'Farm',
        'value': 'Certified Organic'
      },
      {
        'icon': Icons.calendar_today_rounded,
        'title': 'Shelf Life',
        'value': '5-7 days at room temperature'
      },
      {
        'icon': Icons.local_shipping_rounded,
        'title': 'Delivery',
        'value': 'Next Day Available'
      },
      {
        'icon': Icons.assistant_rounded,
        'title': 'Storage',
        'value': 'Store in cool, dry place'
      },
      {
        'icon': Icons.eco_rounded,
        'title': 'Certification',
        'value': 'USDA Organic Certified'
      },
    ];

    return Column(
      children: details.map((detail) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(detail['icon'] as IconData,
                    color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail['title'] as String, style: AppTheme.caption),
                    const SizedBox(height: 4),
                    Text(detail['value'] as String,
                        style: AppTheme.bodyTextBold),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutritionTab() {
    final nutrients = [
      {'name': 'Calories', 'value': '89', 'unit': 'kcal', 'dailyValue': '4%'},
      {'name': 'Total Fat', 'value': '0.3', 'unit': 'g', 'dailyValue': '0%'},
      {'name': 'Sodium', 'value': '1', 'unit': 'mg', 'dailyValue': '0%'},
      {'name': 'Potassium', 'value': '358', 'unit': 'mg', 'dailyValue': '10%'},
      {'name': 'Total Carbs', 'value': '22.8', 'unit': 'g', 'dailyValue': '8%'},
      {
        'name': 'Dietary Fiber',
        'value': '2.6',
        'unit': 'g',
        'dailyValue': '10%'
      },
      {'name': 'Sugars', 'value': '12.2', 'unit': 'g', 'dailyValue': ''},
      {'name': 'Protein', 'value': '1.1', 'unit': 'g', 'dailyValue': '2%'},
      {'name': 'Vitamin C', 'value': '14', 'unit': 'mg', 'dailyValue': '16%'},
      {'name': 'Vitamin B6', 'value': '0.4', 'unit': 'mg', 'dailyValue': '20%'},
    ];

    return Column(
      children: [
        // Nutrition Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nutrition Facts', style: AppTheme.headline3),
                  Text('per 100g', style: AppTheme.caption),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount per serving', style: AppTheme.bodyTextBold),
                  Text('Calories 89',
                      style: AppTheme.bodyTextBold
                          .copyWith(color: AppTheme.primaryColor)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Nutrients List
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: nutrients.map((nutrient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(nutrient['name']!, style: AppTheme.bodyText),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${nutrient['value']} ${nutrient['unit']}',
                        style: AppTheme.bodyTextBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        nutrient['dailyValue']!,
                        style: AppTheme.caption,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        // Health Benefits
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.health_and_safety_rounded,
                      color: AppTheme.successColor),
                  const SizedBox(width: 8),
                  Text('Health Benefits',
                      style: AppTheme.headline3
                          .copyWith(color: AppTheme.successColor)),
                ],
              ),
              const SizedBox(height: 12),
              _buildBenefitItem('Rich in potassium for heart health'),
              _buildBenefitItem('High in fiber for digestive health'),
              _buildBenefitItem('Good source of Vitamin C for immunity'),
              _buildBenefitItem('Natural energy booster'),
              _buildBenefitItem('Supports weight management'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              size: 16, color: AppTheme.successColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTheme.caption),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final averageRating = _calculateAverageRating();
    final ratingDistribution = _calculateRatingDistribution();
    final totalReviews = _reviews.length;

    return Column(
      children: [
        // Rating Summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              // Average Rating
              Column(
                children: [
                  Text(averageRating.toStringAsFixed(1),
                      style: AppTheme.headline1.copyWith(fontSize: 36)),
                  _buildRatingStars(averageRating),
                  Text('$totalReviews reviews', style: AppTheme.caption),
                ],
              ),
              const SizedBox(width: 20),

              // Rating Distribution
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((rating) {
                    final count = ratingDistribution[rating]!;
                    final percentage =
                        totalReviews > 0 ? count / totalReviews : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(rating.toString(), style: AppTheme.smallText),
                          const SizedBox(width: 8),
                          Icon(Icons.star_rounded,
                              size: 16, color: AppTheme.secondaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey[200],
                              color: AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count',
                            style: AppTheme.smallText,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Reviews List
        ..._reviews.map((review) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Review Header
                Row(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        review['userAvatar'],
                        style: AppTheme.bodyTextBold
                            .copyWith(color: AppTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // User Info and Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review['userName'],
                              style: AppTheme.bodyTextBold),
                          Text(review['date'],
                              style: AppTheme.smallText
                                  .copyWith(color: AppTheme.textLight)),
                        ],
                      ),
                    ),

                    // Star Rating
                    _buildRatingStars((review['rating'] as int).toDouble()),
                  ],
                ),
                const SizedBox(height: 12),

                // Review Comment
                Text(review['comment'], style: AppTheme.bodyText),
                const SizedBox(height: 12),

                // Helpful Section
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up_alt_outlined,
                          size: 16, color: AppTheme.textLight),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 30),
                    ),
                    Text('Helpful (${review['helpful']})',
                        style: AppTheme.smallText
                            .copyWith(color: AppTheme.textLight)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text('Report',
                          style: AppTheme.smallText
                              .copyWith(color: AppTheme.textLight)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        // Write Review Button
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to write review screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Write review feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppTheme.primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_rounded,
                    size: 18, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text('Write a Review',
                    style:
                        AppTheme.button.copyWith(color: AppTheme.primaryColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(
      Product product, CartProvider cartProvider, UserProvider userProvider) {
    final totalPrice = product.price * _quantity;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Total Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total', style: AppTheme.caption),
                  const SizedBox(height: 4),
                  Text('\$${totalPrice.toStringAsFixed(2)}',
                      style: AppTheme.headline3
                          .copyWith(color: AppTheme.primaryColor)),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Add to Cart Button
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  cartProvider.addToCart(product, quantity: _quantity);
                  _showAddToCartSuccess(product.name, _quantity);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shopping_cart_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Add to Cart'),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Buy Now Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (userProvider.currentUser == null) {
                    Navigator.pushNamed(context, '/auth');
                    return;
                  }
                  cartProvider.addToCart(product, quantity: _quantity);
                  Navigator.pushNamed(context, '/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text('Buy Now', style: AppTheme.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
