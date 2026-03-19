import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/products_bloc.dart';
import '../bloc/categories_cubit.dart';
import '../../core/design_system/design_tokens.dart';
import '../../core/design_system/product_card.dart';
import '../../core/design_system/search_bar.dart';
import '../../core/design_system/category_chip.dart';
import '../../core/design_system/states.dart';

class ProductListScreen extends StatefulWidget {
  final bool isResponsive;
  final Function(int)? onProductSelected;

  const ProductListScreen({
    Key? key,
    this.isResponsive = false,
    this.onProductSelected,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Fetch initial data
    context.read<ProductsBloc>().add(
          const FetchProductsEvent(isInitial: true),
        );
    context.read<CategoriesCubit>().fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      context.read<ProductsBloc>().add(
            LoadMoreProductsEvent(
              categoryFilter: _selectedCategory,
              searchQuery: _searchController.text,
            ),
          );
    }
  }

  void _handleSearch(String query) {
    context.read<ProductsBloc>().add(
          FetchProductsEvent(
            searchQuery: query,
            categoryFilter: _selectedCategory,
            isInitial: true,
          ),
        );
  }

  void _handleCategorySelect(String category) {
    setState(() {
      _selectedCategory =
          _selectedCategory == category ? null : category;
    });

    context.read<ProductsBloc>().add(
          FetchProductsEvent(
            categoryFilter: _selectedCategory,
            searchQuery: _searchController.text,
            isInitial: true,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: AppSearchBar(
              controller: _searchController,
              onChanged: _handleSearch,
            ),
          ),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.md,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: AppPadding.sm),
                        child: CategoryChip(
                          label: category,
                          isSelected: _selectedCategory == category,
                          onTap: () => _handleCategorySelect(category),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is CategoriesError) {
                return SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Failed to load categories',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              }
              return const SizedBox(height: 50);
            },
          ),
          Expanded(
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                if (state is ProductsInitial) {
                  return const LoadingIndicator(message: 'Loading products...');
                } else if (state is ProductsLoading) {
                  if (state.previousProducts.isEmpty) {
                    return const LoadingIndicator(message: 'Loading products...');
                  }
                  return _buildProductList(
                    context,
                    state.previousProducts,
                    isLoadingMore: true,
                  );
                } else if (state is ProductsLoaded) {
                  return _buildProductList(context, state.products);
                } else if (state is ProductsEmpty) {
                  return EmptyState(
                    message: 'No products found',
                    title: 'Nothing here',
                    icon: Icons.search_off,
                  );
                } else if (state is ProductsError) {
                  return ErrorState(
                    message: state.message,
                    title: 'Error loading products',
                    onRetry: () {
                      context.read<ProductsBloc>().add(
                            FetchProductsEvent(
                              categoryFilter: _selectedCategory,
                              searchQuery: _searchController.text,
                              isInitial: true,
                            ),
                          );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context,
    List<dynamic> products, {
    bool isLoadingMore = false,
  }) {
    return NotificationListener(
      onNotification: (notification) {
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppPadding.md),
        itemCount: products.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == products.length) {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.lg),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          final product = products[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppPadding.md),
            child: ProductCard(
              imageUrl: product.thumbnail,
              title: product.title,
              brand: product.brand,
              price: product.price,
              discountPercentage: product.discountPercentage,
              rating: product.rating,
              reviewCount: 100,
              onTap: () {
                if (widget.isResponsive) {
                  widget.onProductSelected?.call(product.id);
                } else {
                  context.push('/products/${product.id}');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
