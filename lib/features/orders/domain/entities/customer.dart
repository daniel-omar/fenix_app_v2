import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';

class Customer {
  int idCliente;
  int? idTipoDocumento;
  DocumentType? tipoDocumento;
  String numeroDocumento;
  String nombreCliente;
  String apellidoPaterno;
  String apellidoMaterno;
  String? numeroTelefono;
  String? correo;

  Customer({
    required this.idCliente,
    this.tipoDocumento,
    this.idTipoDocumento,
    required this.numeroDocumento,
    required this.nombreCliente,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    this.numeroTelefono,
    this.correo,
  });

  Map<String, dynamic> toJson() => {
        "id_cliente": idCliente,
        "id_tipo_documento": idTipoDocumento,
        "tipo_documento": tipoDocumento,
        "numero_documento": numeroDocumento,
        "nombre_cliente": nombreCliente,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "numero_telefono": numeroTelefono,
        "correo": correo,
      };
}
