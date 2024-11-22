import 'package:dio/dio.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/dio_client.dart';

class OrderDatasourceImpl extends OrderDatasource {
  late final dioClient = DioClient();

  OrderDatasourceImpl();

  @override
  Future<Order> getOrderById(int idOrden) async {
    try {
      final response =
          await dioClient.dio.get('/orders/order/getOrderById/$idOrden');
      final order = OrderMapper.orderJsonToEntity(response.data);
      return order;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw OrderNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Order>> getOrdersByTechnical(int idTecnico,
      {int limit = 10, int offset = 0, List<int>? idsEstadoOrden}) async {
    Map<String, dynamic> body = {};
    if (idsEstadoOrden != null) {
      body["id_estado"] = idsEstadoOrden;
    }

    final response = await dioClient.dio
        .get<List>('/orders/order/getOrdersByTecnico/$idTecnico', data: body);
    final List<Order> orders = [];

    // ignore: no_leading_underscores_for_local_identifiers
    for (final _order in response.data ?? []) {
      orders.add(OrderMapper.orderJsonToEntity(_order));
    }

    return orders;
  }
}
