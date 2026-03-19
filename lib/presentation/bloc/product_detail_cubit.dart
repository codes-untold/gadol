import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

// Events
abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductDetailEvent extends ProductDetailEvent {
  final int productId;

  const FetchProductDetailEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

// States
abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository productRepository;

  ProductDetailCubit({required this.productRepository})
      : super(const ProductDetailInitial());

  Future<void> fetchProductDetail(int productId) async {
    emit(const ProductDetailLoading());
    try {
      final product = await productRepository.getProductById(id: productId);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
