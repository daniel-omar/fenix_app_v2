import 'package:fenix_app_v2/features/orders/domain/entities/material.dart';

abstract class MaterialRepository {
  Future<List<Material>> getByFilters({List<int>? idsMaterialCategory});
  Future<Material> getById(int idMaterial);
}
