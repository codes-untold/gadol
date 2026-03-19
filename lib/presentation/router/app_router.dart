import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/product_list_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/responsive_layout_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/products',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/products',
      builder: (context, state) {
        final screenSize = MediaQuery.of(context).size.width;
        const tabletBreakpoint = 768.0;
        
        if (screenSize >= tabletBreakpoint) {
          return const ResponsiveLayoutScreen();
        } else {
          return const ProductListScreen();
        }
      },
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id'] ?? '0');
            final screenSize = MediaQuery.of(context).size.width;
            const tabletBreakpoint = 768.0;
            
            if (screenSize >= tabletBreakpoint) {
              // On tablet, let the parent handle it
              return const ResponsiveLayoutScreen();
            } else {
              // On phone, show detail screen
              return ProductDetailScreen(productId: id);
            }
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/products'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
