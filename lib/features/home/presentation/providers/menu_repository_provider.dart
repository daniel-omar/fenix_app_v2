import 'package:fenix_app_v2/features/home/domain/domain.dart';
import 'package:fenix_app_v2/features/home/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final menuRepository = MenuRepositoryImpl(MenuDatasourceImpl());

  return menuRepository;
});
