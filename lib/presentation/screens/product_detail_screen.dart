import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/product_detail_cubit.dart';
import '../../core/design_system/design_tokens.dart';
import '../../core/design_system/states.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final bool isResponsive;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.isResponsive = false,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _imageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
    context.read<ProductDetailCubit>().fetchProductDetail(widget.productId);
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailInitial) {
          return _buildScaffold(
            context,
            body: const LoadingIndicator(message: 'Loading product...'),
          );
        } else if (state is ProductDetailLoading) {
          return _buildScaffold(
            context,
            body: const LoadingIndicator(message: 'Loading product...'),
          );
        } else if (state is ProductDetailLoaded) {
          final product = state.product;
          return _buildScaffold(
            context,
            showBackButton: !widget.isResponsive,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _imageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: product.images.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: product.images[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Image indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.md,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand & Category
                        Row(
                          children: [
                            Chip(
                              label: Text(product.brand),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: AppPadding.sm),
                            Chip(
                              label: Text(product.category),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppPadding.md),
                        // Title
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppPadding.md),
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              product.stock > 0
                                  ? '${product.stock} In Stock'
                                  : 'Out of Stock',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: product.stock > 0
                                        ? Colors.green
                                        : Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppPadding.lg),
                        // Price
                        Container(
                          padding: const EdgeInsets.all(AppPadding.md),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                  if (product.discountPercentage > 0) ...[
                                    const SizedBox(width: AppPadding.md),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppPadding.sm,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onError,
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
                        const SizedBox(height: AppPadding.lg),
                        // Description
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppPadding.sm),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.lg),
                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to cart'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Add to Cart'),
                          ),
                        ),
                        const SizedBox(height: AppPadding.md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProductDetailError) {
          return _buildScaffold(
            context,
            body: ErrorState(
              message: state.message,
              title: 'Error loading product',
              onRetry: () {
                context.read<ProductDetailCubit>().fetchProductDetail(
                  widget.productId,
                );
              },
            ),
          );
        }
        return _buildScaffold(context, body: const SizedBox());
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context, {
    required Widget body,
    bool showBackButton = true,
  }) {
    if (widget.isResponsive) {
      return body;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: body,
    );
  }
}
