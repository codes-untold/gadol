import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'design_tokens.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? title;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppPadding.lg),
            if (title != null)
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: AppPadding.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppPadding.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.shopping_bag_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: AppPadding.lg),
            if (title != null)
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: AppPadding.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          if (message != null) ...[
            const SizedBox(height: AppPadding.md),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class ProductListShimmer extends StatelessWidget {
  final int count;

  const ProductListShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppPadding.md),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: AppPadding.md),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surfaceVariant,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppPadding.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 120,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      const SizedBox(height: AppPadding.sm),
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      const SizedBox(height: AppPadding.sm),
                      Container(
                        height: 16,
                        width: 180,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      const SizedBox(height: AppPadding.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 80,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceVariant,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: AppPadding.lg),
              Container(
                height: 20,
                width: 160,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: AppPadding.sm),
              Container(
                height: 20,
                width: 120,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: AppPadding.md),
              Container(
                height: 50,
                width: 100,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: AppPadding.md),
              Container(
                height: 16,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: AppPadding.sm),
              Container(
                height: 16,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              const SizedBox(height: AppPadding.sm),
              Container(
                height: 16,
                width: 200,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
