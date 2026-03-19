import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'core/theme/app_theme.dart';
import 'data/repositories/product_repository.dart';
import 'presentation/bloc/products_bloc.dart';
import 'presentation/bloc/categories_cubit.dart';
import 'presentation/bloc/product_detail_cubit.dart';
import 'presentation/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final productRepository = ProductRepository(
      httpClient: http.Client(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsBloc(
            productRepository: productRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit(
            productRepository: productRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProductDetailCubit(
            productRepository: productRepository,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Product Catalog',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
