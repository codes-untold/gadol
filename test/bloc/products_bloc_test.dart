import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:gadol/presentation/bloc/products_bloc.dart';
import 'package:gadol/data/models/product.dart';
import 'package:mocktail/mocktail.dart';
import '../mocks/mock_product_repository.dart';

void main() {
  group('ProductsBloc', () {
    late MockProductRepository mockProductRepository;
    late ProductsBloc productsBloc;

    setUp(() {
      mockProductRepository = MockProductRepository();
      productsBloc = ProductsBloc(productRepository: mockProductRepository);
    });

    tearDown(() {
      productsBloc.close();
    });

    final mockProducts = [
      Product(
        id: 1,
        title: 'Product 1',
        description: 'Description 1',
        price: 10.0,
        discountPercentage: 5.0,
        rating: 4.0,
        stock: 10,
        brand: 'Brand 1',
        category: 'Category 1',
        thumbnail: 'https://example.com/1.jpg',
        images: ['https://example.com/1.jpg'],
      ),
      Product(
        id: 2,
        title: 'Product 2',
        description: 'Description 2',
        price: 20.0,
        discountPercentage: 15.0,
        rating: 4.5,
        stock: 5,
        brand: 'Brand 2',
        category: 'Category 2',
        thumbnail: 'https://example.com/2.jpg',
        images: ['https://example.com/2.jpg'],
      ),
    ];

    blocTest<ProductsBloc, ProductsState>(
      'should emit [ProductsLoading, ProductsLoaded] when fetch is successful',
      build: () {
        when(
          () => mockProductRepository.getProducts(limit: 20, skip: 0),
        ).thenAnswer(
          (_) async => ProductResponse(
            products: mockProducts,
            total: 2,
            skip: 0,
            limit: 20,
          ),
        );
        return productsBloc;
      },
      act: (bloc) => bloc.add(const FetchProductsEvent(isInitial: true)),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>()
            .having((state) => state.products.length, 'products length', 2)
            .having((state) => state.hasMoreData, 'hasMoreData', false),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit ProductsEmpty when no products found',
      build: () {
        when(
          () => mockProductRepository.getProducts(limit: 20, skip: 0),
        ).thenAnswer(
          (_) async =>
              ProductResponse(products: [], total: 0, skip: 0, limit: 20),
        );
        return productsBloc;
      },
      act: (bloc) => bloc.add(const FetchProductsEvent(isInitial: true)),
      expect: () => [isA<ProductsLoading>(), isA<ProductsEmpty>()],
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit ProductsError when fetch fails',
      build: () {
        when(
          () => mockProductRepository.getProducts(limit: 20, skip: 0),
        ).thenThrow(Exception('Network error'));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const FetchProductsEvent(isInitial: true)),
      expect: () => [isA<ProductsLoading>(), isA<ProductsError>()],
    );

    blocTest<ProductsBloc, ProductsState>(
      'should load more products when reaching bottom',
      build: () {
        when(
          () => mockProductRepository.getProducts(limit: 20, skip: 0),
        ).thenAnswer(
          (_) async => ProductResponse(
            products: mockProducts,
            total: 50,
            skip: 0,
            limit: 20,
          ),
        );
        when(
          () => mockProductRepository.getProducts(limit: 20, skip: 20),
        ).thenAnswer(
          (_) async => ProductResponse(
            products: [
              Product(
                id: 3,
                title: 'Product 3',
                description: 'Description 3',
                price: 30.0,
                discountPercentage: 20.0,
                rating: 5.0,
                stock: 15,
                brand: 'Brand 3',
                category: 'Category 3',
                thumbnail: 'https://example.com/3.jpg',
                images: ['https://example.com/3.jpg'],
              ),
            ],
            total: 50,
            skip: 20,
            limit: 20,
          ),
        );
        return productsBloc;
      },
      act: (bloc) async {
        bloc.add(const FetchProductsEvent(isInitial: true));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const LoadMoreProductsEvent());
      },
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>().having(
          (state) => state.products.length,
          'initial products',
          2,
        ),
        isA<ProductsLoaded>().having(
          (state) => state.products.length,
          'total products',
          3,
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'should search products when query is provided',
      build: () {
        when(
          () => mockProductRepository.searchProducts(
            query: 'phone',
            limit: 20,
            skip: 0,
          ),
        ).thenAnswer(
          (_) async => ProductResponse(
            products: [mockProducts[0]],
            total: 1,
            skip: 0,
            limit: 20,
          ),
        );
        return productsBloc;
      },
      act: (bloc) => bloc.add(
        const FetchProductsEvent(searchQuery: 'phone', isInitial: true),
      ),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>().having(
          (state) => state.searchQuery,
          'searchQuery',
          'phone',
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'should filter products by category',
      build: () {
        when(
          () => mockProductRepository.getProductsByCategory(
            category: 'electronics',
            limit: 20,
            skip: 0,
          ),
        ).thenAnswer(
          (_) async => ProductResponse(
            products: mockProducts,
            total: 2,
            skip: 0,
            limit: 20,
          ),
        );
        return productsBloc;
      },
      act: (bloc) => bloc.add(
        const FetchProductsEvent(
          categoryFilter: 'electronics',
          isInitial: true,
        ),
      ),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>().having(
          (state) => state.categoryFilter,
          'categoryFilter',
          'electronics',
        ),
      ],
    );
  });
}
