import 'package:dio/dio.dart';
import 'package:fenix_app_v2/features/orders/domain/datasources/document_type_datasource.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/document_type_mapper.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/entities/response_main.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/mappers/response_main_mapper.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/dio_client.dart';

class DocumentTypeDatasourceImpl extends DocumentTypeDatasource {
  late final dioClient = DioClient();

  DocumentTypeDatasourceImpl();

  @override
  Future<DocumentType> getById(int idTipoDocumento) async {
    try {
      final response = await dioClient.dio
          .get('/users/document_type/getById/$idTipoDocumento');

      ResponseMain responseMain =
          ResponseMainMapper.responseJsonToEntity(response.data);

      final documentType =
          DocumentTypeMapper.documentTypeJsonToEntity(responseMain.data);
      return documentType;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw OrderNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<DocumentType>> getList() async {
    final response =
        await dioClient.dio.get('/users/document_type/getList');
    ResponseMain responseMain =
        ResponseMainMapper.responseJsonToEntity(response.data);

    final List<DocumentType> documentsTypes = [];

    // ignore: no_leading_underscores_for_local_identifiers
    for (final _documentType in responseMain.data ?? []) {
      documentsTypes
          .add(DocumentTypeMapper.documentTypeJsonToEntity(_documentType));
    }

    return documentsTypes;
  }
}
