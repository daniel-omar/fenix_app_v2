import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialsProvider = StateNotifierProvider.autoDispose
    .family<MaterialsNotifier, MaterialsState, int>((ref, idMaterialCategory) {
  final materialRepository = ref.watch(materialRepositoryProvider);

  return MaterialsNotifier(
      materialRepository: materialRepository,
      idMaterialCategory: idMaterialCategory);
});

class MaterialsNotifier extends StateNotifier<MaterialsState> {
  final MaterialRepository materialRepository;

  MaterialsNotifier({
    required this.materialRepository,
    required int idMaterialCategory,
  }) : super(MaterialsState()) {
    getByIdCategory(idMaterialCategory);
  }

  Future<void> getByIdCategory(int idMaterialCategory) async {
    try {
      state = state.copyWith(isLoading: true);

      List<Material> materials = await materialRepository
          .getByFilters(idsMaterialCategory: [idMaterialCategory]);

      // materials = [
      //   Material(idMaterial: 0, codigoMaterial: "0", nombreMaterial: "Seleccione"),
      //   ...materials
      // ];

      state = state.copyWith(
        isLoading: false,
        materials: materials,
      );
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class MaterialsState {
  final bool isLoading;
  final bool isSaving;
  final List<Material>? materials;

  MaterialsState({
    this.isLoading = true,
    this.isSaving = false,
    this.materials,
  });

  MaterialsState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<Material>? materials,
  }) =>
      MaterialsState(
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        materials: materials ?? this.materials,
      );
}
