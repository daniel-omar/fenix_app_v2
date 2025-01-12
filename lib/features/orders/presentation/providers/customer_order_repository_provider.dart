import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/datasources/customer_order_datasource_impl.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/repositories/customer_order_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerOrderRepositoryProvider =
    Provider<CustomerOrderRepository>((ref) {
  final customerOrderRepository =
      CustomerOrderRepositoryImpl(CustomerOrderDatasourceImpl());
  return customerOrderRepository;
});
