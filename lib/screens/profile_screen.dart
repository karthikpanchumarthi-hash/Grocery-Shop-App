import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/models/user_model.dart';
import 'package:groceryshopapp/screens/order_history_screen.dart';
import 'package:groceryshopapp/screens/edit_profile_screen.dart';
import 'package:groceryshopapp/screens/address_management_screen.dart';
import 'package:groceryshopapp/screens/payment_management_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.person_outline_rounded,
      'title': 'Edit Profile',
      'subtitle': 'Update your personal information',
      'color': AppTheme.primaryColor,
      'onTap': (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()));
      },
    },
    {
      'icon': Icons.location_on_outlined,
      'title': 'My Addresses',
      'subtitle': 'Manage your delivery addresses',
      'color': Colors.orange,
      'onTap': (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddressManagementScreen()));
      },
    },
    {
      'icon': Icons.credit_card_outlined,
      'title': 'Payment Methods',
      'subtitle': 'Manage your payment options',
      'color': Colors.green,
      'onTap': (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PaymentManagementScreen()));
      },
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'title': 'My Orders',
      'subtitle': 'View your order history and track orders',
      'color': Colors.purple,
      'onTap': (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
      },
    },
    {
      'icon': Icons.favorite_outline_rounded,
      'title': 'Wishlist',
      'subtitle': 'Your saved items',
      'color': Colors.red,
      'onTap': (context) {
        // Navigate to wishlist screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wishlist feature coming soon!')),
        );
      },
    },
    {
      'icon': Icons.notifications_outlined,
      'title': 'Notifications',
      'subtitle': 'Manage your notifications',
      'color': Colors.blue,
      'onTap': (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications feature coming soon!')),
        );
      },
    },
    {
      'icon': Icons.security_outlined,
      'title': 'Privacy & Security',
      'subtitle': 'Control your privacy settings',
      'color': Colors.teal,
      'onTap': (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Privacy settings coming soon!')),
        );
      },
    },
    {
      'icon': Icons.help_outline_rounded,
      'title': 'Help & Support',
      'subtitle': 'Get help and contact support',
      'color': Colors.brown,
      'onTap': (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Help & support coming soon!')),
        );
      },
    },
    {
      'icon': Icons.info_outline_rounded,
      'title': 'About Us',
      'subtitle': 'Learn more about ARMart',
      'color': Colors.indigo,
      'onTap': (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('About us information coming soon!')),
        );
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout_rounded,
                  color: AppTheme.errorColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Logout?', style: AppTheme.headline2),
          ],
        ),
        content: Text(
          'Are you sure you want to logout from your account?',
          style: AppTheme.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTheme.bodyText),
          ),
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout', style: AppTheme.button),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logout();

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppTheme.surfaceColor,
              elevation: 0,
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Profile', style: AppTheme.headline2),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),

                // Profile Header
                _buildProfileHeader(user),
                const SizedBox(height: 32),

                // Quick Stats
                _buildQuickStats(userProvider),
                const SizedBox(height: 24),

                // Menu Items
                _buildMenuSection(),
                const SizedBox(height: 32),

                // Logout Button
                _buildLogoutButton(),
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: user?.profileImage != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user!.profileImage!),
                  )
                : const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
          ),
          const SizedBox(width: 20),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Guest User',
                  style: AppTheme.headline2,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'Not logged in',
                  style: AppTheme.caption,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user != null
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user != null ? 'Verified' : 'Guest Mode',
                        style: AppTheme.smallText.copyWith(
                          color: user != null
                              ? AppTheme.successColor
                              : AppTheme.warningColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (user != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Gold Member',
                          style: AppTheme.smallText.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Edit Button
          if (user != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.edit_rounded,
                    color: AppTheme.primaryColor, size: 20),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditProfileScreen()));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.shopping_bag_rounded,
            value: '12',
            label: 'Orders',
            color: AppTheme.primaryColor,
          ),
          _buildStatItem(
            icon: Icons.location_on_rounded,
            value: userProvider.addresses.length.toString(),
            label: 'Addresses',
            color: Colors.orange,
          ),
          _buildStatItem(
            icon: Icons.credit_card_rounded,
            value: userProvider.paymentMethods.length.toString(),
            label: 'Payments',
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.star_rounded,
            value: '4.8',
            label: 'Rating',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppTheme.headline3),
        Text(label,
            style: AppTheme.smallText.copyWith(color: AppTheme.textSecondary)),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: _menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => item['onTap'](context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: index < _menuItems.length - 1
                        ? BorderSide(color: Colors.grey[200]!)
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'],
                        color: item['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], style: AppTheme.bodyTextBold),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'],
                            style: AppTheme.caption,
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.textLight,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.currentUser == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text('Login to Continue', style: AppTheme.button),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: _isLoading ? null : _showLogoutConfirmation,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.errorColor,
            side: const BorderSide(color: AppTheme.errorColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.errorColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text('Logout',
                        style: AppTheme.button
                            .copyWith(color: AppTheme.errorColor)),
                  ],
                ),
        ),
      ),
    );
  }
}
