import 'package:fenix_app_v2/features/orders/domain/domain.dart';

class ClientMapper {
  static clientJsonToEntity(Map<String, dynamic> json) => Client(
        idCliente: json["id_cliente"],
        nombreCliente: json["nombre_cliente"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
      );
}
