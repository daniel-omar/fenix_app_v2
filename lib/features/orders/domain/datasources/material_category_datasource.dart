import 'package:fenix_app_v2/features/orders/domain/entities/material_category.dart';

abstract class MaterialCategoryDatasource {
  Future<List<MaterialCategory>> getAll();
  Future<List<MaterialCategory>> getList(Map<String, dynamic> body);
  Future<MaterialCategory> getById(int idMaterialCategory);
}
