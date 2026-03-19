import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:gadol/presentation/bloc/categories_cubit.dart';
import 'package:mocktail/mocktail.dart';
import '../mocks/mock_product_repository.dart';

void main() {
  group('CategoriesCubit', () {
    late MockProductRepository mockProductRepository;
    late CategoriesCubit categoriesCubit;

    setUp(() {
      mockProductRepository = MockProductRepository();
      categoriesCubit = CategoriesCubit(productRepository: mockProductRepository);
    });

    tearDown(() {
      categoriesCubit.close();
    });

    final mockCategories = ['Electronics', 'Fashion', 'Food', 'Books'];

    blocTest<CategoriesCubit, CategoriesState>(
      'should emit [CategoriesLoading, CategoriesLoaded] when fetch succeeds',
      build: () {
        when(() => mockProductRepository.getCategories())
            .thenAnswer((_) async => mockCategories);
        return categoriesCubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesLoaded>()
            .having((state) => state.categories.length, 'categories length', 4),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'should emit CategoriesError when fetch fails',
      build: () {
        when(() => mockProductRepository.getCategories())
            .thenThrow(Exception('Network error'));
        return categoriesCubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesError>(),
      ],
    );
  });
}
