import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialProvider =
    StateNotifierProvider<MaterialNotifier, MaterialState>((ref) {
  final materialRepository = ref.watch(materialRepositoryProvider);

  return MaterialNotifier(materialRepository: materialRepository);
});

class MaterialNotifier extends StateNotifier<MaterialState> {
  final MaterialRepository materialRepository;

  MaterialNotifier({
    required this.materialRepository,
  }) : super(MaterialState());

  void getMaterial() async {
    try {
      state = state.copyWith(isLoading: true);

      Material material = await materialRepository.getById(state.idMaterial!);

      state = state.copyWith(isLoading: false, material: material);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }

  void onMaterialChanged(int idMaterial) {
    state = state.copyWith(idMaterial: idMaterial);
    getMaterial();
  }
}

class MaterialState {
  final int? idMaterial;
  final Material? material;
  final bool isLoading;
  final bool isSaving;

  MaterialState(
      {this.idMaterial = 0,
      this.material,
      this.isLoading = true,
      this.isSaving = false});

  MaterialState copyWith({
    int? idMaterial,
    Material? material,
    bool? isLoading,
    bool? isSaving,
  }) =>
      MaterialState(
        idMaterial: idMaterial ?? this.idMaterial,
        material: material ?? this.material,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
