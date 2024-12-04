import 'package:fenix_app_v2/features/orders/domain/entities/material.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/material_category.dart';

abstract class MaterialDatasource {
  Future<List<Material>> getByFilters({List<int>? idsMaterialCategory});
  Future<Material> getById(int idMaterial);
  Future<List<MaterialCategory>> getListGroupByFilters(
      {List<int>? idsMaterialCategory, bool? esSeriado});
}
