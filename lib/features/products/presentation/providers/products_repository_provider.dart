import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fenix_app_v2/features/products/domain/domain.dart';
import 'package:fenix_app_v2/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:fenix_app_v2/features/products/infrastructure/repositories/products_repository_impl.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final productsRepository = ProductsRepositoryImpl(ProductsDatasourceImpl());

  return productsRepository;
});
