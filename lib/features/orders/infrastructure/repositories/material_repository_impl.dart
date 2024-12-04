import 'package:fenix_app_v2/features/orders/domain/domain.dart';

class MaterialRepositoryImpl extends MaterialRepository {
  final MaterialDatasource datasource;

  MaterialRepositoryImpl(this.datasource);

  @override
  Future<Material> getById(int idMaterial) {
    return datasource.getById(idMaterial);
  }

  @override
  Future<List<Material>> getByFilters({List<int>? idsMaterialCategory}) {
    return datasource.getByFilters(idsMaterialCategory: idsMaterialCategory);
  }

  @override
  Future<List<MaterialCategory>> getListGroupByFilters(
      {List<int>? idsMaterialCategory, bool? esSeriado}) {
    return datasource.getListGroupByFilters(
        idsMaterialCategory: idsMaterialCategory, esSeriado: esSeriado);
  }
}
