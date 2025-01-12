import '../entities/client.dart';

abstract class CustomerOrderDatasource {
  Future<Client> getCustomerByIdOrder(int idOrden);
}
