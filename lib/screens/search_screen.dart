import 'package:groceryshopapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:groceryshopapp/theme/app_theme.dart';
import 'package:groceryshopapp/widgets/product_card.dart';
import 'package:groceryshopapp/providers/product_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  List<Product> _searchResults = [];
  List<Product> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Load recent searches (mock data)
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _recentSearches = productProvider.products.take(2).toList();

    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final results = productProvider.searchProducts(query);

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildSearchAppBar(),
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildRecentSearches()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar() {
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
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Search for groceries...',
                    hintStyle: AppTheme.caption,
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppTheme.primaryColor),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                  ),
                  style: AppTheme.bodyText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Searches', style: AppTheme.headline2),
          const SizedBox(height: 16),
          ..._recentSearches.map((product) {
            return Material(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  _searchController.text = product.name;
                  _performSearch(product.name);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.history_rounded,
                          color: AppTheme.textLight, size: 20),
                      const SizedBox(width: 12),
                      Text(product.name, style: AppTheme.bodyText),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: AppTheme.textLight, size: 16),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Text('Popular Categories', style: AppTheme.headline2),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children:
                ['Fruits', 'Vegetables', 'Dairy', 'Bakery'].map((category) {
              return Material(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    _searchController.text = category;
                    _performSearch(category);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Center(
                      child: Text(category, style: AppTheme.bodyTextBold),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
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
              child: const Icon(
                Icons.search_off_rounded,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No results found',
              style: AppTheme.headline2,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return ProductCard(product: _searchResults[index]);
      },
    );
  }
}
