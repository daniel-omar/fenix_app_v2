import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';
import 'package:fenix_app_v2/features/orders/domain/repositories/document_type_repository.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/document_type_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final documentTypesProvider = StateNotifierProvider.autoDispose<
    DocumentTypesNotifier,
    DocumentTypesState
    //int
    >((ref) {
  final documentTypeRepository = ref.watch(documentTypeRepositoryProvider);

  return DocumentTypesNotifier(
    documentTypeRepository: documentTypeRepository,
    //idMaterialCategory: idMaterialCategory,
  );
});

class DocumentTypesNotifier extends StateNotifier<DocumentTypesState> {
  final DocumentTypeRepository documentTypeRepository;

  DocumentTypesNotifier({
    required this.documentTypeRepository,
    //required int? idMaterialCategory,
  }) : super(DocumentTypesState()) {
    loadDocumentTypes();
  }

  Future<void> loadDocumentTypes() async {
    try {
      state = state.copyWith(isLoading: true);

      final documentTypes = await documentTypeRepository.getList();

      state = state.copyWith(isLoading: false, documentTypes: documentTypes);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class DocumentTypesState {
  final bool isLoading;
  final bool isSaving;
  final List<DocumentType>? documentTypes;

  DocumentTypesState({
    this.isLoading = true,
    this.isSaving = false,
    this.documentTypes,
  });

  DocumentTypesState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<DocumentType>? documentTypes,
  }) =>
      DocumentTypesState(
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        documentTypes: documentTypes ?? this.documentTypes,
      );
}
