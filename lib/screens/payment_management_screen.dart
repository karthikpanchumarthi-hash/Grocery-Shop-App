import 'package:flutter/material.dart';
import 'package:groceryshopapp/models/payment_model.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({super.key});

  @override
  State<PaymentManagementScreen> createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final paymentMethods = userProvider.paymentMethods;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditPaymentScreen()),
              );
            },
          ),
        ],
      ),
      body: paymentMethods.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                return _buildPaymentCard(paymentMethods[index], userProvider);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
              Icons.credit_card_outlined,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Payment Methods',
            style: AppTheme.headline2,
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first payment method',
            style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddEditPaymentScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Payment Method'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
      PaymentMethod paymentMethod, UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getPaymentColor(paymentMethod.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getPaymentIcon(paymentMethod.type),
            color: _getPaymentColor(paymentMethod.type),
            size: 20,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  paymentMethod.name,
                  style: AppTheme.bodyTextBold,
                ),
                if (paymentMethod.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Default',
                      style: AppTheme.smallText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            if (paymentMethod.type == 'card')
              Text(
                paymentMethod.maskedCardNumber,
                style: AppTheme.caption,
              ),
            if (paymentMethod.type == 'upi')
              Text(
                'UPI ID: ${paymentMethod.upiId}',
                style: AppTheme.caption,
              ),
            if (paymentMethod.type == 'cod')
              Text(
                'Pay when you receive your order',
                style: AppTheme.caption,
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            _handlePaymentAction(value, paymentMethod, userProvider);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit Payment Method'),
            ),
            if (!paymentMethod.isDefault)
              const PopupMenuItem(
                value: 'set_default',
                child: Text('Set as Default'),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete Payment Method'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentColor(String type) {
    switch (type) {
      case 'card':
        return AppTheme.primaryColor;
      case 'upi':
        return Colors.blue;
      case 'paypal':
        return Colors.blue[800]!;
      case 'cod':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'card':
        return Icons.credit_card_rounded;
      case 'upi':
        return Icons.payment_rounded;
      case 'paypal':
        return Icons.paypal_rounded;
      case 'cod':
        return Icons.money_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  void _handlePaymentAction(
      String action, PaymentMethod paymentMethod, UserProvider userProvider) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditPaymentScreen(paymentMethod: paymentMethod),
          ),
        );
        break;
      case 'set_default':
        userProvider.setDefaultPaymentMethod(paymentMethod.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment method set as default'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(paymentMethod, userProvider);
        break;
    }
  }

  void _showDeleteConfirmation(
      PaymentMethod paymentMethod, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method?'),
        content: Text('Are you sure you want to delete ${paymentMethod.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.deletePaymentMethod(paymentMethod.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method deleted successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddEditPaymentScreen extends StatefulWidget {
  final PaymentMethod? paymentMethod;

  const AddEditPaymentScreen({super.key, this.paymentMethod});

  @override
  State<AddEditPaymentScreen> createState() => _AddEditPaymentScreenState();
}

class _AddEditPaymentScreenState extends State<AddEditPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _upiIdController = TextEditingController();

  String _selectedType = 'card';
  bool _isDefault = false;
  bool _isLoading = false;

  final List<String> _paymentTypes = ['card', 'upi', 'cod'];

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      _loadPaymentData();
    }
  }

  void _loadPaymentData() {
    final paymentMethod = widget.paymentMethod!;
    _selectedType = paymentMethod.type;
    _nameController.text = paymentMethod.name;
    _cardNumberController.text = paymentMethod.cardNumber ?? '';
    _expiryDateController.text = paymentMethod.expiryDate ?? '';
    _cvvController.text = paymentMethod.cvv ?? '';
    _upiIdController.text = paymentMethod.upiId ?? '';
    _isDefault = paymentMethod.isDefault;
  }

  void _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final paymentMethod = PaymentMethod(
      id: widget.paymentMethod?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      name: _nameController.text.trim(),
      cardNumber:
          _selectedType == 'card' ? _cardNumberController.text.trim() : null,
      expiryDate:
          _selectedType == 'card' ? _expiryDateController.text.trim() : null,
      cvv: _selectedType == 'card' ? _cvvController.text.trim() : null,
      upiId: _selectedType == 'upi' ? _upiIdController.text.trim() : null,
      isDefault: _isDefault,
    );

    if (widget.paymentMethod == null) {
      userProvider.addPaymentMethod(paymentMethod);
    } else {
      userProvider.updatePaymentMethod(paymentMethod.id, paymentMethod);
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.paymentMethod == null
            ? 'Payment method added successfully'
            : 'Payment method updated successfully'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.paymentMethod == null
            ? 'Add Payment Method'
            : 'Edit Payment Method'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Payment Type
              _buildPaymentTypeSelector(),
              const SizedBox(height: 20),

              // Form Fields based on type
              _buildFormFields(),
              const SizedBox(height: 20),

              // Default Payment Toggle
              _buildDefaultPaymentToggle(),
              const SizedBox(height: 40),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method Type', style: AppTheme.bodyTextBold),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _paymentTypes.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(_getPaymentTypeName(type)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedType = type);
              },
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getPaymentTypeName(String type) {
    switch (type) {
      case 'card':
        return 'Credit/Debit Card';
      case 'upi':
        return 'UPI';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return type;
    }
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Payment Method Name',
            hintText: _getPaymentNameHint(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a name for this payment method';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        if (_selectedType == 'card') ...[
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter card number';
              }
              if (value.trim().replaceAll(' ', '').length != 16) {
                return 'Please enter a valid 16-digit card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter expiry date';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter CVV';
                    }
                    if (value.trim().length != 3) {
                      return 'Please enter a valid 3-digit CVV';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
        if (_selectedType == 'upi') ...[
          TextFormField(
            controller: _upiIdController,
            decoration: const InputDecoration(
              labelText: 'UPI ID',
              hintText: 'yourname@upi',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter UPI ID';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid UPI ID';
              }
              return null;
            },
          ),
        ],
        if (_selectedType == 'cod') ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pay with cash when you receive your order',
                    style:
                        AppTheme.caption.copyWith(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getPaymentNameHint() {
    switch (_selectedType) {
      case 'card':
        return 'e.g., My Visa Card';
      case 'upi':
        return 'e.g., My UPI';
      case 'cod':
        return 'e.g., Cash Payment';
      default:
        return 'Payment method name';
    }
  }

  Widget _buildDefaultPaymentToggle() {
    return Row(
      children: [
        Switch(
          value: _isDefault,
          onChanged: (value) {
            setState(() => _isDefault = value);
          },
          activeThumbColor: AppTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set as Default Payment', style: AppTheme.bodyTextBold),
              Text(
                'Use this payment method for all orders',
                style: AppTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _savePaymentMethod,
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
                widget.paymentMethod == null
                    ? 'Add Payment Method'
                    : 'Update Payment Method',
                style: AppTheme.button,
              ),
      ),
    );
  }
}
