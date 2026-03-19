import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:gadol/presentation/bloc/product_detail_cubit.dart';
import 'package:gadol/data/models/product.dart';
import 'package:mocktail/mocktail.dart';
import '../mocks/mock_product_repository.dart';

void main() {
  group('ProductDetailCubit', () {
    late MockProductRepository mockProductRepository;
    late ProductDetailCubit productDetailCubit;

    setUp(() {
      mockProductRepository = MockProductRepository();
      productDetailCubit =
          ProductDetailCubit(productRepository: mockProductRepository);
    });

    tearDown(() {
      productDetailCubit.close();
    });

    final mockProduct = Product(
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
      images: ['https://example.com/image.jpg'],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'should emit [ProductDetailLoading, ProductDetailLoaded] when fetch succeeds',
      build: () {
        when(() => mockProductRepository.getProductById(id: 1))
            .thenAnswer((_) async => mockProduct);
        return productDetailCubit;
      },
      act: (cubit) => cubit.fetchProductDetail(1),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailLoaded>()
            .having((state) => state.product.id, 'product id', 1)
            .having((state) => state.product.title, 'product title', 'Test Product'),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'should emit ProductDetailError when fetch fails',
      build: () {
        when(() => mockProductRepository.getProductById(id: 1))
            .thenThrow(Exception('Product not found'));
        return productDetailCubit;
      },
      act: (cubit) => cubit.fetchProductDetail(1),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailError>(),
      ],
    );
  });
}
