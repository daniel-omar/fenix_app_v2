import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';

abstract class DocumentTypeDatasource {
  Future<List<DocumentType>> getList();
  Future<DocumentType> getById(int idTipoDocumento);
}
