import 'package:fenix_app_v2/features/orders/domain/datasources/customer_order_datasource.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart';

class CustomerOrderRepositoryImpl extends CustomerOrderRepository {
  final CustomerOrderDatasource datasource;

  CustomerOrderRepositoryImpl(this.datasource);

  @override
  Future<Customer> getCustomerByIdOrder(int idOrden) {
    return datasource.getCustomerByIdOrder(idOrden);
  }
}
