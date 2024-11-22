import 'package:fenix_app_v2/features/orders/domain/domain.dart';

class OrderStatusMapper {
  static orderStatusJsonToEntity(Map<String, dynamic> json) => OrderStatus(
        idEstadoOrden: json["id_estado_orden"],
        nombreEstado: json["nombre_estado_orden"],
        esActivo: true,
      );
}
