import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_category_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final materialCategorysProvider = StateNotifierProvider.autoDispose<
    MaterialCategorysNotifier,
    MaterialCategorysState
    //int
    >((ref) {
  final materialCategoryRepository =
      ref.watch(materialCategoryRepositoryProvider);

  return MaterialCategorysNotifier(
    materialCategoryRepository: materialCategoryRepository,
    //idMaterialCategory: idMaterialCategory,
  );
});

class MaterialCategorysNotifier extends StateNotifier<MaterialCategorysState> {
  final MaterialCategoryRepository materialCategoryRepository;

  MaterialCategorysNotifier({
    required this.materialCategoryRepository,
    //required int? idMaterialCategory,
  }) : super(MaterialCategorysState()) {
    loadMaterialCategorys();
  }

  Future<void> loadMaterialCategorys() async {
    try {
      state = state.copyWith(isLoading: true);

      final materialCategorys = await materialCategoryRepository.getAll();

      state = state.copyWith(
          isLoading: false, materialCategorys: materialCategorys);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class MaterialCategorysState {
  final bool isLoading;
  final bool isSaving;
  final List<MaterialCategory>? materialCategorys;

  MaterialCategorysState({
    this.isLoading = true,
    this.isSaving = false,
    this.materialCategorys,
  });

  MaterialCategorysState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<MaterialCategory>? materialCategorys,
  }) =>
      MaterialCategorysState(
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        materialCategorys: materialCategorys ?? this.materialCategorys,
      );
}
