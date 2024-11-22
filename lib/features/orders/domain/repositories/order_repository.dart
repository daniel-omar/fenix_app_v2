import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersByTechnical(int idTecnico,
      {int limit = 10, int offset = 0, List<int>? idsEstadoOrden});
  Future<Order> getOrderById(int idOrden);
}