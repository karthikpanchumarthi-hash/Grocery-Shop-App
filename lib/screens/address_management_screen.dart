import 'package:flutter/material.dart';
import 'package:groceryshopapp/models/address_model.dart';
import 'package:groceryshopapp/providers/user_provider.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final addresses = userProvider.addresses;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditAddressScreen()),
              );
            },
          ),
        ],
      ),
      body: addresses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(addresses[index], userProvider);
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
              Icons.location_on_outlined,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Addresses Added',
            style: AppTheme.headline2,
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first delivery address',
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
                      builder: (_) => const AddEditAddressScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Address'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Address address, UserProvider userProvider) {
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
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getAddressIcon(address.type),
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  address.name,
                  style: AppTheme.bodyTextBold,
                ),
                if (address.isDefault) ...[
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
            Text(
              address.fullAddress,
              style: AppTheme.caption,
            ),
            if (address.phone != null) ...[
              const SizedBox(height: 4),
              Text(
                'Phone: ${address.phone}',
                style: AppTheme.caption,
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            _handleAddressAction(value, address, userProvider);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit Address'),
            ),
            if (!address.isDefault)
              const PopupMenuItem(
                value: 'set_default',
                child: Text('Set as Default'),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete Address'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAddressIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'family':
        return Icons.family_restroom_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  void _handleAddressAction(
      String action, Address address, UserProvider userProvider) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditAddressScreen(address: address),
          ),
        );
        break;
      case 'set_default':
        userProvider.setDefaultAddress(address.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address set as default'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(address, userProvider);
        break;
    }
  }

  void _showDeleteConfirmation(Address address, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address?'),
        content:
            Text('Are you sure you want to delete ${address.name} address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.deleteAddress(address.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted successfully'),
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

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedType = 'Home';
  bool _isDefault = false;
  bool _isLoading = false;

  final List<String> _addressTypes = ['Home', 'Work', 'Family', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _loadAddressData();
    }
  }

  void _loadAddressData() {
    final address = widget.address!;
    _nameController.text = address.name;
    _streetController.text = address.street;
    _cityController.text = address.city;
    _stateController.text = address.state;
    _zipCodeController.text = address.zipCode;
    _countryController.text = address.country;
    _phoneController.text = address.phone ?? '';
    _instructionsController.text = address.instructions ?? '';
    _selectedType = address.type;
    _isDefault = address.isDefault;
  }

  void _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final address = Address(
      id: widget.address?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      name: _nameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipCodeController.text.trim(),
      country: _countryController.text.trim(),
      isDefault: _isDefault,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
    );

    if (widget.address == null) {
      userProvider.addAddress(address);
    } else {
      userProvider.updateAddress(address.id, address);
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.address == null
            ? 'Address added successfully'
            : 'Address updated successfully'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Address Type
              _buildAddressTypeSelector(),
              const SizedBox(height: 20),

              // Form Fields
              _buildFormFields(),
              const SizedBox(height: 20),

              // Default Address Toggle
              _buildDefaultAddressToggle(),
              const SizedBox(height: 40),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Address Type', style: AppTheme.bodyTextBold),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _addressTypes.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(type),
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

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Address Name',
            hintText: 'e.g., Home, Work, etc.',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter address name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _streetController,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            hintText: 'e.g., 123 Main Street',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter street address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'ZIP Code',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter ZIP code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter country';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number (Optional)',
            prefixIcon: Icon(Icons.phone_rounded),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _instructionsController,
          decoration: const InputDecoration(
            labelText: 'Delivery Instructions (Optional)',
            hintText: 'e.g., Leave at front door, Ring bell, etc.',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDefaultAddressToggle() {
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
              Text('Set as Default Address', style: AppTheme.bodyTextBold),
              Text(
                'Use this address for all deliveries',
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
        onPressed: _isLoading ? null : _saveAddress,
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
                widget.address == null ? 'Add Address' : 'Update Address',
                style: AppTheme.button,
              ),
      ),
    );
  }
}
