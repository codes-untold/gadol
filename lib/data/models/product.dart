import 'dart:developer' as developer;

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  /// Factory constructor for creating a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    String sanitizeImageUrl(String? url) {
      if (url == null || url.isEmpty) {
        developer.log('Missing or empty image URL');
        return 'https://via.placeholder.com/300x300?text=No+Image';
      }
      return url;
    }

    try {
      final price = (json['price'] as num?)?.toDouble() ?? 0.0;
      if (price < 0) {
        developer.log('Negative price detected for product ${json['id']}: $price');
      }

      final images = (json['images'] as List<dynamic>?)
              ?.map((e) => sanitizeImageUrl(e.toString()))
              .toList() ??
          [];

      return Product(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? 'Unknown Product',
        description: json['description'] as String? ?? '',
        price: price,
        discountPercentage:
            (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        brand: json['brand'] as String? ?? 'Unknown Brand',
        category: json['category'] as String? ?? 'Uncategorized',
        thumbnail: sanitizeImageUrl(json['thumbnail'] as String?),
        images: images.isNotEmpty
            ? images
            : [sanitizeImageUrl(json['thumbnail'] as String?)],
      );
    } catch (e) {
      developer.log('Error parsing product: $e');
      rethrow;
    }
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'brand': brand,
        'category': category,
        'thumbnail': thumbnail,
        'images': images,
      };

  @override
  String toString() => 'Product(id: $id, title: $title, price: $price)';
}

class ProductResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    try {
      final products = (json['products'] as List<dynamic>?)
              ?.map((p) => Product.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [];

      return ProductResponse(
        products: products,
        total: json['total'] as int? ?? 0,
        skip: json['skip'] as int? ?? 0,
        limit: json['limit'] as int? ?? 0,
      );
    } catch (e) {
      developer.log('Error parsing ProductResponse: $e');
      rethrow;
    }
  }
}
