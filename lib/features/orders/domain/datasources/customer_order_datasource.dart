import '../entities/customer.dart';

abstract class CustomerOrderDatasource {
  Future<Customer> getCustomerByIdOrder(int idOrden);
}
