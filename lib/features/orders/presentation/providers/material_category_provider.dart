import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_category_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final materialCategoryProvider = StateNotifierProvider.autoDispose<
    MaterialCategoryNotifier,
    MaterialCategoryState
    //int
    >((ref) {
  final materialCategoryRepository =
      ref.watch(materialCategoryRepositoryProvider);

  return MaterialCategoryNotifier(
    materialCategoryRepository: materialCategoryRepository,
    //idMaterialCategory: idMaterialCategory,
  );
});

class MaterialCategoryNotifier extends StateNotifier<MaterialCategoryState> {
  final MaterialCategoryRepository materialCategoryRepository;

  MaterialCategoryNotifier({
    required this.materialCategoryRepository,
    //required int? idMaterialCategory,
  }) : super(MaterialCategoryState(idMaterialCategory: 0));

  Future<void> loadMaterialCategorys() async {
    try {
      state = state.copyWith(isLoading: true);

      final materialCategorys = await materialCategoryRepository.getAll();

      final materialCategory = materialCategorys.first;

      state = state.copyWith(
          isLoading: false,
          materialCategorys: materialCategorys,
          materialCategory: materialCategory,
          idMaterialCategory: materialCategory.idCategoria);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }

  void onCategoryChanged(int idMaterialCategory) {
    state = state.copyWith(idMaterialCategory: idMaterialCategory);
  }
}

class MaterialCategoryState {
  final int idMaterialCategory;
  final MaterialCategory? materialCategory;
  final bool isLoading;
  final bool isSaving;
  final List<MaterialCategory>? materialCategorys;

  MaterialCategoryState({
    required this.idMaterialCategory,
    this.materialCategory,
    this.isLoading = true,
    this.isSaving = false,
    this.materialCategorys,
  });

  MaterialCategoryState copyWith({
    int? idMaterialCategory,
    MaterialCategory? materialCategory,
    bool? isLoading,
    bool? isSaving,
    List<MaterialCategory>? materialCategorys,
  }) =>
      MaterialCategoryState(
        idMaterialCategory: idMaterialCategory ?? this.idMaterialCategory,
        materialCategory: materialCategory ?? this.materialCategory,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        materialCategorys: materialCategorys ?? this.materialCategorys,
      );
}
