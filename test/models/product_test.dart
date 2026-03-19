import 'package:flutter_test/flutter_test.dart';
import 'package:gadol/data/models/product.dart';

void main() {
  group('Product Model', () {
    test('should create a Product from valid JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'A test product',
        'price': 99.99,
        'discountPercentage': 10.0,
        'rating': 4.5,
        'stock': 10,
        'brand': 'Test Brand',
        'category': 'Test Category',
        'thumbnail': 'https://example.com/image.jpg',
        'images': [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.brand, 'Test Brand');
      expect(product.rating, 4.5);
      expect(product.images.length, 2);
    });

    test('should provide default values for missing fields', () {
      final json = {'id': 1, 'thumbnail': 'https://example.com/image.jpg'};

      final product = Product.fromJson(json);

      expect(product.title, 'Unknown Product');
      expect(product.brand, 'Unknown Brand');
      expect(product.category, 'Uncategorized');
      expect(product.description, '');
      expect(product.price, 0.0);
      expect(product.rating, 0.0);
      expect(product.stock, 0);
    });

    test('should use placeholder image for missing thumbnail', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'thumbnail': '',
        'images': [],
      };

      final product = Product.fromJson(json);

      expect(product.thumbnail.contains('placeholder'), true);
    });

    test('should handle negative price gracefully', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': -10.0,
        'thumbnail': 'https://example.com/image.jpg',
      };

      final product = Product.fromJson(json);

      expect(product.price, -10.0); // Stores as-is, UI handles display
    });

    test('should convert Product to JSON', () {
      final product = Product(
        id: 1,
        title: 'Test Product',
        description: 'A test product',
        price: 99.99,
        discountPercentage: 10.0,
        rating: 4.5,
        stock: 10,
        brand: 'Test Brand',
        category: 'Test Category',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
      );

      final json = product.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Product');
      expect(json['price'], 99.99);
      expect(json['brand'], 'Test Brand');
    });

    test('should use first image as fallback when images list is empty', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'thumbnail': 'https://example.com/thumbnail.jpg',
        'images': [],
      };

      final product = Product.fromJson(json);

      expect(product.images.isNotEmpty, true);
      expect(product.images[0], 'https://example.com/thumbnail.jpg');
    });

    test('ProductResponse should parse multiple products', () {
      final json = {
        'products': [
          {
            'id': 1,
            'title': 'Product 1',
            'price': 10.0,
            'thumbnail': 'https://example.com/1.jpg',
          },
          {
            'id': 2,
            'title': 'Product 2',
            'price': 20.0,
            'thumbnail': 'https://example.com/2.jpg',
          },
        ],
        'total': 100,
        'skip': 0,
        'limit': 20,
      };

      final response = ProductResponse.fromJson(json);

      expect(response.products.length, 2);
      expect(response.total, 100);
      expect(response.skip, 0);
      expect(response.limit, 20);
    });

    test('ProductResponse should handle empty products list', () {
      final json = {'products': [], 'total': 0, 'skip': 0, 'limit': 20};

      final response = ProductResponse.fromJson(json);

      expect(response.products.isEmpty, true);
      expect(response.total, 0);
    });
  });
}
