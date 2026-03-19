import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

// Events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductsEvent {
  final String? categoryFilter;
  final String? searchQuery;
  final bool isInitial;

  const FetchProductsEvent({
    this.categoryFilter,
    this.searchQuery,
    this.isInitial = false,
  });

  @override
  List<Object?> get props => [categoryFilter, searchQuery, isInitial];
}

class LoadMoreProductsEvent extends ProductsEvent {
  final String? categoryFilter;
  final String? searchQuery;

  const LoadMoreProductsEvent({this.categoryFilter, this.searchQuery});

  @override
  List<Object?> get props => [categoryFilter, searchQuery];
}

class UpdateCategoryFilterEvent extends ProductsEvent {
  final String? category;

  const UpdateCategoryFilterEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateSearchQueryEvent extends ProductsEvent {
  final String query;

  const UpdateSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  final List<Product> previousProducts;

  const ProductsLoading({this.previousProducts = const []});

  @override
  List<Object?> get props => [previousProducts];
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasMoreData;
  final String? categoryFilter;
  final String? searchQuery;

  const ProductsLoaded({
    required this.products,
    required this.hasMoreData,
    this.categoryFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
    products,
    hasMoreData,
    categoryFilter,
    searchQuery,
  ];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductsEmpty extends ProductsState {
  final String? categoryFilter;
  final String? searchQuery;

  const ProductsEmpty({this.categoryFilter, this.searchQuery});

  @override
  List<Object?> get props => [categoryFilter, searchQuery];
}

// Bloc
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository productRepository;
  static const int pageSize = 20;

  int _currentSkip = 0;
  List<Product> _allProducts = [];
  String? _currentCategory;
  String? _currentSearchQuery;
  int _totalProducts = 0;

  ProductsBloc({required this.productRepository})
    : super(const ProductsInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<UpdateCategoryFilterEvent>(_onUpdateCategoryFilter);
    on<UpdateSearchQueryEvent>(_onUpdateSearchQuery);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading(previousProducts: _allProducts));

    _currentCategory = event.categoryFilter;
    _currentSearchQuery = event.searchQuery;
    _currentSkip = 0;
    _allProducts = [];

    try {
      final response = await _fetchProductsWithFilters(
        category: event.categoryFilter,
        search: event.searchQuery,
        limit: pageSize,
        skip: 0,
      );

      _allProducts = response.products;
      _totalProducts = response.total;

      if (_allProducts.isEmpty) {
        emit(
          ProductsEmpty(
            categoryFilter: event.categoryFilter,
            searchQuery: event.searchQuery,
          ),
        );
      } else {
        _currentSkip = pageSize;
        emit(
          ProductsLoaded(
            products: _allProducts,
            hasMoreData: _allProducts.length < _totalProducts,
            categoryFilter: event.categoryFilter,
            searchQuery: event.searchQuery,
          ),
        );
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;

    try {
      final response = await _fetchProductsWithFilters(
        category: event.categoryFilter,
        search: event.searchQuery,
        limit: pageSize,
        skip: _currentSkip,
      );

      _allProducts = [..._allProducts, ...response.products];

      final hasMore = _allProducts.length < _totalProducts;

      emit(
        ProductsLoaded(
          products: _allProducts,
          hasMoreData: hasMore,
          categoryFilter: event.categoryFilter,
          searchQuery: event.searchQuery,
        ),
      );

      if (hasMore) {
        _currentSkip += pageSize;
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onUpdateCategoryFilter(
    UpdateCategoryFilterEvent event,
    Emitter<ProductsState> emit,
  ) async {
    add(
      FetchProductsEvent(
        categoryFilter: event.category,
        searchQuery: _currentSearchQuery,
        isInitial: true,
      ),
    );
  }

  Future<void> _onUpdateSearchQuery(
    UpdateSearchQueryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    add(
      FetchProductsEvent(
        categoryFilter: _currentCategory,
        searchQuery: event.query,
        isInitial: true,
      ),
    );
  }

  Future<ProductResponse> _fetchProductsWithFilters({
    String? category,
    String? search,
    required int limit,
    required int skip,
  }) async {
    if (search != null && search.isNotEmpty) {
      return productRepository.searchProducts(
        query: search,
        limit: limit,
        skip: skip,
      );
    } else if (category != null && category.isNotEmpty) {
      return productRepository.getProductsByCategory(
        category: category,
        limit: limit,
        skip: skip,
      );
    } else {
      return productRepository.getProducts(limit: limit, skip: skip);
    }
  }
}
