import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/document_type_mapper.dart';

class ClientMapper {
  static clientJsonToEntity(Map<String, dynamic> json) => Customer(
        idCliente: json["id_cliente"],
        //idTipoDocumento: json["id_tipo_documento"],
        tipoDocumento: json["tipo_documento"] != null
            ? DocumentTypeMapper.documentTypeJsonToEntity(
                json["tipo_documento"])
            : null,
        numeroDocumento: json["numero_documento"],
        nombreCliente: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        numeroTelefono: json["numero_telefono"],
        correo: json["correo"],
      );
}
