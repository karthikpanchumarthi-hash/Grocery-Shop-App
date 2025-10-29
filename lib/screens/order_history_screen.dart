import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  final List<String> _orderTabs = [
    'All',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];

  // Sample orders data - in real app, this would come from OrderProvider
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ARM-2024-001',
      'date': '2024-01-15',
      'status': 'delivered',
      'items': [
        {
          'name': 'Organic Bananas',
          'quantity': 2,
          'image': '🍌',
          'price': 2.99
        },
        {'name': 'Fresh Avocado', 'quantity': 3, 'image': '🥑', 'price': 1.99},
      ],
      'total': 12.45,
      'deliveryDate': 'Delivered on Jan 16, 2024',
      'trackingNumber': 'TRK123456789',
      'address': '123 Main St, New York, NY 10001',
    },
    {
      'id': 'ARM-2024-002',
      'date': '2024-01-14',
      'status': 'shipped',
      'items': [
        {
          'name': 'Organic Strawberries',
          'quantity': 1,
          'image': '🍓',
          'price': 4.99
        },
        {'name': 'Broccoli', 'quantity': 2, 'image': '🥦', 'price': 2.49},
      ],
      'total': 9.97,
      'deliveryDate': 'Expected by Jan 17, 2024',
      'trackingNumber': 'TRK123456788',
      'address': '123 Main St, New York, NY 10001',
    },
    {
      'id': 'ARM-2024-003',
      'date': '2024-01-13',
      'status': 'processing',
      'items': [
        {'name': 'Milk', 'quantity': 1, 'image': '🥛', 'price': 4.99},
        {'name': 'Bread', 'quantity': 2, 'image': '🍞', 'price': 3.49},
      ],
      'total': 11.97,
      'deliveryDate': 'Processing',
      'trackingNumber': 'TRK123456787',
      'address': '456 Work Ave, New York, NY 10002',
    },
    {
      'id': 'ARM-2024-004',
      'date': '2024-01-10',
      'status': 'cancelled',
      'items': [
        {'name': 'Eggs', 'quantity': 1, 'image': '🥚', 'price': 5.99},
      ],
      'total': 5.99,
      'deliveryDate': 'Cancelled on Jan 10, 2024',
      'trackingNumber': null,
      'address': '123 Main St, New York, NY 10001',
    },
    {
      'id': 'ARM-2024-005',
      'date': '2024-01-08',
      'status': 'delivered',
      'items': [
        {'name': 'Chicken Breast', 'quantity': 2, 'image': '🍗', 'price': 8.99},
        {'name': 'Rice', 'quantity': 1, 'image': '🍚', 'price': 4.49},
      ],
      'total': 22.47,
      'deliveryDate': 'Delivered on Jan 9, 2024',
      'trackingNumber': 'TRK123456786',
      'address': '123 Main St, New York, NY 10001',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _orderTabs.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    final selectedTab = _orderTabs[_tabController.index].toLowerCase();
    if (selectedTab == 'all') return _orders;
    return _orders.where((order) => order['status'] == selectedTab).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return AppTheme.successColor;
      case 'shipped':
        return AppTheme.infoColor;
      case 'processing':
        return AppTheme.warningColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'delivered':
        return 'Delivered';
      case 'shipped':
        return 'Shipped';
      case 'processing':
        return 'Processing';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'shipped':
        return Icons.local_shipping_rounded;
      case 'processing':
        return Icons.schedule_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.shopping_bag_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _animationController,
            child: child,
          );
        },
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _orderTabs.map((tab) {
                  return _filteredOrders.isEmpty
                      ? _buildEmptyState(tab)
                      : _buildOrdersList();
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
                iconSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text('Order History', style: AppTheme.headline2),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: _showFilterOptions,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.surfaceColor,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3,
        labelStyle: AppTheme.bodyTextBold,
        unselectedLabelStyle: AppTheme.bodyText,
        tabs: _orderTabs.map((tab) {
          final count = tab == 'All'
              ? _orders.length
              : _orders
                  .where((order) => order['status'] == tab.toLowerCase())
                  .length;

          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tab),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count.toString(),
                    style: AppTheme.smallText.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onTap: (index) => setState(() {}),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(_filteredOrders[index]),
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ${order['id']}', style: AppTheme.headline3),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order['status']),
                          size: 14,
                          color: _getStatusColor(order['status']),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(order['status']),
                          style: AppTheme.smallText.copyWith(
                            color: _getStatusColor(order['status']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Placed on ${order['date']}', style: AppTheme.caption),
              const SizedBox(height: 16),

              // Order Items Preview
              _buildOrderItemsPreview(order),
              const SizedBox(height: 16),

              // Delivery Info
              _buildDeliveryInfo(order),
              const SizedBox(height: 16),

              // Order Footer with Actions
              _buildOrderFooter(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsPreview(Map<String, dynamic> order) {
    final items = order['items'] as List;
    final visibleItems = items.take(2).toList();
    final remainingCount = items.length - 2;

    return Column(
      children: [
        Row(
          children: [
            // Item Images Stack
            Stack(
              children: [
                ...visibleItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Positioned(
                    left: index * 30.0,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.surfaceColor, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          item['image'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }),
                if (remainingCount > 0)
                  Positioned(
                    left: 60.0,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.surfaceColor, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '+$remainingCount',
                          style: AppTheme.smallText.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 80),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${items.length} items • ${order['deliveryDate']}',
                    style: AppTheme.bodyTextBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['address'],
                    style: AppTheme.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping_rounded,
            size: 16,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Status',
                  style:
                      AppTheme.smallText.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  order['deliveryDate'],
                  style: AppTheme.smallText,
                ),
              ],
            ),
          ),
          if (order['trackingNumber'] != null)
            Text(
              'Track #${order['trackingNumber']}',
              style: AppTheme.smallText.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderFooter(Map<String, dynamic> order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount',
              style: AppTheme.caption,
            ),
            Text(
              '\$${order['total'].toStringAsFixed(2)}',
              style: AppTheme.headline3.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Track Order Button (for active orders)
            if (order['status'] != 'cancelled' &&
                order['status'] != 'delivered')
              OutlinedButton(
                onPressed: () => _trackOrder(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Track Order'),
              ),

            if (order['status'] != 'cancelled' &&
                order['status'] != 'delivered')
              const SizedBox(width: 8),

            // Reorder Button (for delivered orders)
            if (order['status'] == 'delivered')
              OutlinedButton(
                onPressed: () => _reorder(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Reorder'),
              ),

            const SizedBox(width: 8),

            // Details Button
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward_rounded,
                    size: 18, color: AppTheme.primaryColor),
                onPressed: () => _showOrderDetails(order),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(String tab) {
    final emptyStateData = {
      'All': {
        'icon': Icons.shopping_bag_outlined,
        'title': 'No orders yet',
        'subtitle': 'Your orders will appear here once you start shopping',
        'buttonText': 'Start Shopping',
      },
      'Processing': {
        'icon': Icons.schedule_rounded,
        'title': 'No active orders',
        'subtitle': 'Orders being processed will appear here',
        'buttonText': 'Browse Products',
      },
      'Shipped': {
        'icon': Icons.local_shipping_rounded,
        'title': 'No shipped orders',
        'subtitle': 'Orders on their way will appear here',
        'buttonText': 'Browse Products',
      },
      'Delivered': {
        'icon': Icons.check_circle_outline_rounded,
        'title': 'No delivered orders',
        'subtitle': 'Completed orders will appear here',
        'buttonText': 'Browse Products',
      },
      'Cancelled': {
        'icon': Icons.cancel_outlined,
        'title': 'No cancelled orders',
        'subtitle': 'Cancelled orders will appear here',
        'buttonText': 'Browse Products',
      },
    };

    final data = emptyStateData[tab]!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data['icon'] as IconData,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              data['title'] as String,
              style: AppTheme.headline2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              data['subtitle'] as String,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(data['buttonText'] as String),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter Options', style: AppTheme.headline3),
            const SizedBox(height: 20),
            const Text('Filter functionality coming soon'),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Details', style: AppTheme.headline2),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Order #${order['id']}', style: AppTheme.headline3),
                    const SizedBox(height: 8),
                    Text('Placed on ${order['date']}', style: AppTheme.caption),
                    const SizedBox(height: 20),
                    Text('Items', style: AppTheme.headline3),
                    const SizedBox(height: 12),
                    ...(order['items'] as List).map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Text(item['image'],
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'] as String,
                                        style: AppTheme.bodyTextBold),
                                    Text('Qty: ${item['quantity']}',
                                        style: AppTheme.caption),
                                  ],
                                ),
                              ),
                              Text(
                                  '\$${((item['price'] as num) * (item['quantity'] as num)).toStringAsFixed(2)}',
                                  style: AppTheme.bodyTextBold),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total', style: AppTheme.bodyText),
                              Text(
                                  '\$${(order['total'] as num).toStringAsFixed(2)}',
                                  style: AppTheme.headline3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _trackOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tracking order ${order['id']}...')),
    );
  }

  void _reorder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Order added to cart')),
    );
  }
}
