import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class ProductRepository {
  static const String baseUrl = 'https://dummyjson.com';
  final http.Client httpClient;

  ProductRepository({required this.httpClient});

  /// Fetch paginated products
  Future<ProductResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/products?limit=$limit&skip=$skip');
      developer.log('Fetching products from: $uri');

      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductResponse.fromJson(json);
      } else {
        throw Exception(
            'Failed to load products: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      developer.log('Error fetching products: $e');
      rethrow;
    }
  }

  /// Search products by query
  Future<ProductResponse> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    if (query.isEmpty) {
      return getProducts(limit: limit, skip: skip);
    }

    try {
      final uri = Uri.parse('$baseUrl/products/search?q=$query&limit=$limit&skip=$skip');
      developer.log('Searching products: $uri');

      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductResponse.fromJson(json);
      } else {
        throw Exception(
            'Failed to search products: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      developer.log('Error searching products: $e');
      rethrow;
    }
  }

  /// Fetch all product categories
  Future<List<String>> getCategories() async {
    try {
      final uri = Uri.parse('$baseUrl/products/categories');
      developer.log('Fetching categories from: $uri');

      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        final categories = jsonDecode(response.body) as List<dynamic>;
        return categories.map((c) => c.toString()).toList();
      } else {
        throw Exception(
            'Failed to load categories: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      developer.log('Error fetching categories: $e');
      rethrow;
    }
  }

  /// Fetch products by category
  Future<ProductResponse> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    try {
      final uri = Uri.parse(
          '$baseUrl/products/category/$category?limit=$limit&skip=$skip');
      developer.log('Fetching products for category: $category from: $uri');

      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductResponse.fromJson(json);
      } else {
        throw Exception(
            'Failed to load products by category: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      developer.log('Error fetching products by category: $e');
      rethrow;
    }
  }

  /// Fetch a single product by ID
  Future<Product> getProductById({required int id}) async {
    try {
      final uri = Uri.parse('$baseUrl/products/$id');
      developer.log('Fetching product by id: $uri');

      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Product.fromJson(json);
      } else {
        throw Exception(
            'Failed to load product: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      developer.log('Error fetching product by id: $e');
      rethrow;
    }
  }
}
