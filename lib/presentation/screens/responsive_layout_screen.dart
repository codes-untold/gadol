import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_detail_cubit.dart';
import 'product_list_screen.dart';
import 'product_detail_screen.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  const ResponsiveLayoutScreen({super.key});

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  int? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog'), centerTitle: false),
      body: Row(
        children: [
          // Left panel: Product list
          SizedBox(
            width: 400,
            child: ProductListScreen(
              isResponsive: true,
              onProductSelected: (productId) {
                setState(() {
                  _selectedProductId = productId;
                });
                context.read<ProductDetailCubit>().fetchProductDetail(
                  productId,
                );
              },
            ),
          ),
          // Divider
          VerticalDivider(
            width: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
          // Right panel: Product detail or empty state
          Expanded(
            child: _selectedProductId != null
                ? ProductDetailScreen(
                    productId: _selectedProductId!,
                    isResponsive: true,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select a product',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose a product from the list to view details',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
