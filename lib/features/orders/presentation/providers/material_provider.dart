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

  void onMaterialChanged(int idMaterial) {
    state = state.copyWith(idMaterial: idMaterial);
  }
}

class MaterialState {
  final int? idMaterial;
  final Material? material;
  final bool isLoading;
  final bool isSaving;

  MaterialState(
      {this.idMaterial,
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
