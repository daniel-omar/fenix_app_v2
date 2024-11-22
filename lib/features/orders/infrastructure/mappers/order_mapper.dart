import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/activity_mapper.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/client_mapper.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/order_status_mapper.dart';

class OrderMapper {
  static orderJsonToEntity(Map<String, dynamic> json) => Order(
        idOrden: json["id_orden"],
        numeroOrden: json["numero_orden"],
        direccion: json["direccion"],
        fechaProgramacion: json["fecha_programacion"],
        idEstadoOrden: json["id_estado_orden"],
        idCliente: json["id_cliente"],
        idActividad: json["id_actividad"],
        cliente: ClientMapper.clientJsonToEntity(json["cliente"]),
        estadoOrden:
            OrderStatusMapper.orderStatusJsonToEntity(json["estado_orden"]),
        actividad: ActivityMapper.activityJsonToEntity(json["actividad"]),
      );
}
