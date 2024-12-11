import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';

class DocumentTypeMapper {
  static documentTypeJsonToEntity(Map<String, dynamic> json) => DocumentType(
        idTipoDocumento: json["id_tipo_documento"],
        nombreTipoDocumento: json["nombre_tipo_documento"],
      );
}
