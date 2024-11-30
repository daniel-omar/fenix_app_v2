import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/infrastructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  final materialRepository = MaterialRepositoryImpl(MaterialDatasourceImpl());
  return materialRepository;
});
