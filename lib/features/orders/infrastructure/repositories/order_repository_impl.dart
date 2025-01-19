import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:image_picker/image_picker.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderDatasource datasource;

  OrderRepositoryImpl(this.datasource);

  @override
  Future<Order> getOrderById(int idOrden) {
    return datasource.getOrderById(idOrden);
  }

  @override
  Future<List<Order>> getOrdersByTechnical(int idTecnico,
      {int limit = 10, int offset = 0, List<int>? idsEstadoOrden}) {
    return datasource.getOrdersByTechnical(idTecnico,
        limit: limit, offset: offset, idsEstadoOrden: idsEstadoOrden);
  }

  @override
  Future<bool> liquidateOrder(
      Map<String, dynamic> data, List<XFile> evidencias) {
    return datasource.liquidateOrder(data, evidencias);
  }
}
