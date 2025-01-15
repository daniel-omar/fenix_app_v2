import '../entities/customer.dart';

abstract class CustomerOrderRepository {
  Future<Customer> getCustomerByIdOrder(int idOrden);
}
