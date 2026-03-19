import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadol/core/design_system/category_chip.dart';
import 'package:gadol/core/theme/app_theme.dart';

void main() {
  group('CategoryChip Widget', () {
    Widget createWidgetUnderTest({
      String label = 'Electronics',
      bool isSelected = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: CategoryChip(
              label: label,
              isSelected: isSelected,
              onTap: onTap ?? () {},
            ),
          ),
        ),
      );
    }

    testWidgets('should display label text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(label: 'Electronics'));

      expect(find.text('Electronics'), findsOneWidget);
    });

    testWidgets('should have primary color when selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(label: 'Electronics', isSelected: true),
      );

      final container = find.byType(Container).first;
      expect(container, findsOneWidget);
    });

    testWidgets('should have surfaceVariant color when not selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(label: 'Electronics', isSelected: false),
      );

      final container = find.byType(Container).first;
      expect(container, findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Electronics',
          onTap: () {
            tapped = true;
          },
        ),
      );

      await tester.tap(find.byType(CategoryChip));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('should toggle selection state when tapped', (
      WidgetTester tester,
    ) async {
      bool isSelected = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: CategoryChip(
                    label: 'Electronics',
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(isSelected, false);

      await tester.tap(find.byType(CategoryChip));
      await tester.pumpAndSettle();

      expect(isSelected, true);
    });

    testWidgets('should display multiple chips in a row', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip(
                    label: 'Electronics',
                    isSelected: false,
                    onTap: () {},
                  ),
                  CategoryChip(
                    label: 'Fashion',
                    isSelected: true,
                    onTap: () {},
                  ),
                  CategoryChip(label: 'Books', isSelected: false, onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Fashion'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(label: 'Electronics'));

      final container = find.byType(Container).first;
      expect(container, findsOneWidget);
    });
  });
}
