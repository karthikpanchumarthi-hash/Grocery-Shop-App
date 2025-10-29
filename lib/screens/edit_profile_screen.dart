import 'package:flutter/material.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  void _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      userProvider.updateUserProfile(updatedUser);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture
              _buildProfilePicture(),
              const SizedBox(height: 32),

              // Form Fields
              _buildFormFields(),
              const SizedBox(height: 40),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // Implement profile picture change
          },
          child: Text(
            'Change Photo',
            style: AppTheme.captionBold.copyWith(color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_rounded),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email_rounded),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number (Optional)',
            prefixIcon: Icon(Icons.phone_rounded),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Save Changes',
                style: AppTheme.button,
              ),
      ),
    );
  }
}
