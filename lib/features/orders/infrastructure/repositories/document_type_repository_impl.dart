import 'package:fenix_app_v2/features/orders/domain/datasources/document_type_datasource.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';
import 'package:fenix_app_v2/features/orders/domain/repositories/document_type_repository.dart';

class DocumentTypeRepositoryImpl extends DocumentTypeRepository {
  final DocumentTypeDatasource datasource;

  DocumentTypeRepositoryImpl(this.datasource);

  @override
  Future<DocumentType> getById(int idTipoDocumento) {
    return datasource.getById(idTipoDocumento);
  }

  @override
  Future<List<DocumentType>> getList() {
    return datasource.getList();
  }
}
