import 'package:flutter/material.dart';
import 'package:groceryshopapp/models/user_model.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Update the _login method in AuthScreen
  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Create user from login data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = User(
      id: '1',
      name: _emailController.text.split('@').first, // Use email prefix as name
      email: _emailController.text,
      phone: '+1 234 567 8900',
    );

    userProvider.login(user);

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _signup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    if (!_agreeToTerms) {
      _showError('Please agree to the Terms & Conditions');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    // Create user from signup data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = User(
      id: '1',
      name: _nameController.text,
      email: _emailController.text,
      phone: '+1 234 567 8900',
    );

    userProvider.login(user);

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabBar(),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildSignupForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: const Icon(
            Icons.shopping_cart_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text('Welcome to ARMart', style: AppTheme.headline2),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue your grocery journey',
          style: AppTheme.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.button.copyWith(fontSize: 14),
        unselectedLabelStyle: AppTheme.button.copyWith(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'LOGIN'),
          Tab(text: 'SIGN UP'),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style:
                    AppTheme.captionBold.copyWith(color: AppTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            text: 'LOGIN',
            onPressed: _isLoading ? null : _login,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 24),
          _buildSocialLogin(),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            obscureText: _obscureConfirmPassword,
            onToggle: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          const SizedBox(height: 16),
          _buildTermsCheckbox(),
          const SizedBox(height: 24),
          _buildActionButton(
            text: 'CREATE ACCOUNT',
            onPressed: _isLoading ? null : _signup,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 24),
          _buildSocialLogin(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTheme.bodyText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: AppTheme.bodyText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            const Icon(Icons.lock_rounded, color: AppTheme.primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            color: AppTheme.textLight,
          ),
          onPressed: onToggle,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) => setState(() => _agreeToTerms = value!),
          activeColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  text: 'I agree to the ',
                  style: AppTheme.caption,
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: AppTheme.captionBold
                          .copyWith(color: AppTheme.primaryColor),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppTheme.captionBold
                          .copyWith(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(text, style: AppTheme.button),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or continue with',
                style: AppTheme.caption,
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 20),

        // Fixed social buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _buildSocialButton(
              icon: Icons.facebook_rounded,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _buildSocialButton(
              icon: Icons.apple_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 52,
      height: 52,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: AppTheme.textSecondary),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
