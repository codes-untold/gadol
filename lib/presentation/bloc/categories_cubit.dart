import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/product_repository.dart';

// Events
abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends CategoriesEvent {
  const FetchCategoriesEvent();
}

// States
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<String> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class CategoriesCubit extends Cubit<CategoriesState> {
  final ProductRepository productRepository;

  CategoriesCubit({required this.productRepository})
    : super(const CategoriesInitial());

  Future<void> fetchCategories() async {
    emit(const CategoriesLoading());
    try {
      final categories = await productRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
