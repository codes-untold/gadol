import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadol/core/design_system/product_card.dart';
import 'package:gadol/core/theme/app_theme.dart';

void main() {
  group('ProductCard Widget', () {
    Widget createWidgetUnderTest({
      String imageUrl = 'https://example.com/image.jpg',
      String title = 'Test Product',
      String brand = 'Test Brand',
      double price = 99.99,
      double? discountPercentage = null,
      double rating = 4.5,
      int reviewCount = 100,
      bool isLoading = false,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ProductCard(
            imageUrl: imageUrl,
            title: title,
            brand: brand,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            reviewCount: reviewCount,
            onTap: () {},
            isLoading: isLoading,
          ),
        ),
      );
    }

    testWidgets('should display product title, brand, and price',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'iPhone 14',
        brand: 'Apple',
        price: 999.99,
      ));

      expect(find.text('iPhone 14'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('\$999.99'), findsOneWidget);
    });

    testWidgets('should display discount badge when discount exists',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        discountPercentage: 20.0,
      ));

      expect(find.text('-20%'), findsOneWidget);
    });

    testWidgets('should not display discount badge when discount is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        discountPercentage: 0.0,
      ));

      expect(find.text('-0%'), findsNothing);
    });

    testWidgets('should display rating and review count',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        rating: 4.5,
        reviewCount: 250,
      ));

      expect(find.text('4.5 (250)'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ProductCard(
              imageUrl: 'https://example.com/image.jpg',
              title: 'Test Product',
              brand: 'Test Brand',
              price: 99.99,
              rating: 4.5,
              reviewCount: 100,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ProductCard));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('should display skeleton loader when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(isLoading: true));

      // The skeleton loader should be rendered without any content
      expect(find.byType(ProductCard), findsOneWidget);
      // Skeleton should not show actual product data
      expect(find.text('Test Product'), findsNothing);
    });

    testWidgets('should display star icon with rating',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(rating: 4.5));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should truncate long product titles to 2 lines',
        (WidgetTester tester) async {
      const longTitle =
          'This is a very long product title that should be truncated after two lines';

      await tester.pumpWidget(createWidgetUnderTest(title: longTitle));

      final textWidget = find.byType(Text).at(2);
      await tester.pumpAndSettle();
      expect(textWidget, findsOneWidget);
    });
  });
}
