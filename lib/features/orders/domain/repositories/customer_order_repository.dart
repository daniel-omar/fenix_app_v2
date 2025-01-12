import '../entities/client.dart';

abstract class CustomerOrderRepository {
  Future<Client> getCustomerByIdOrder(int idOrden);
}
