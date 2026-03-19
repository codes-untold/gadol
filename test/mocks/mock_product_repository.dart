import 'package:gadol/data/repositories/product_repository.dart';
import 'package:gadol/data/models/product.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class MockProduct extends Mock implements Product {}
