import 'package:fenix_app_v2/features/orders/domain/domain.dart';

class MaterialCategoryRepositoryImpl extends MaterialCategoryRepository {
  final MaterialCategoryDatasource datasource;

  MaterialCategoryRepositoryImpl(this.datasource);

  @override
  Future<MaterialCategory> getById(int idMaterialCategory) {
    return datasource.getById(idMaterialCategory);
  }

  @override
  Future<List<MaterialCategory>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<List<MaterialCategory>> getList(Map<String, dynamic> body) {
    return datasource.getList(body);
  }
}
