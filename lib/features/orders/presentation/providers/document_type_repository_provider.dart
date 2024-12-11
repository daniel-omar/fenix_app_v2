import 'package:fenix_app_v2/features/orders/domain/repositories/document_type_repository.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/datasources/document_type_datasource_impl.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/repositories/document_type_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentTypeRepositoryProvider = Provider<DocumentTypeRepository>((ref) {
  final documentTypeRepository =
      DocumentTypeRepositoryImpl(DocumentTypeDatasourceImpl());
  return documentTypeRepository;
});
