import 'package:dio/dio.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/entities/response_main.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/mappers/response_main_mapper.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/dio_client.dart';

class MaterialDatasourceImpl extends MaterialDatasource {
  late final dioClient = DioClient();

  MaterialDatasourceImpl();

  @override
  Future<Material> getById(int idMaterial) async {
    try {
      final response =
          await dioClient.dio.get('/materials/material/getById/$idMaterial');

      ResponseMain responseMain =
          ResponseMainMapper.responseJsonToEntity(response.data);

      final material = MaterialMapper.materialJsonToEntity(responseMain.data);
      return material;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw OrderNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Material>> getByFilters({List<int>? idsMaterialCategory}) async {
    Map<String, dynamic> body = {};
    if (idsMaterialCategory != null) {
      body["ids_categoria_material"] = idsMaterialCategory;
    }
    final response =
        await dioClient.dio.get('/materials/material/getList', data: body);
    ResponseMain responseMain =
        ResponseMainMapper.responseJsonToEntity(response.data);

    final List<Material> materials = [];

    // ignore: no_leading_underscores_for_local_identifiers
    for (final _material in responseMain.data ?? []) {
      materials.add(MaterialMapper.materialJsonToEntity(_material));
    }

    return materials;
  }

  @override
  Future<List<MaterialCategory>> getListGroupByFilters(
      {List<int>? idsMaterialCategory, bool? esSeriado}) async {
    Map<String, dynamic> body = {};
    if (esSeriado != null) {
      body["es_seriado"] = esSeriado;
    }

    final response =
        await dioClient.dio.get('/materials/material/getListGroup', data: body);
    ResponseMain responseMain =
        ResponseMainMapper.responseJsonToEntity(response.data);

    final List<MaterialCategory> materialsCategory = [];

    // ignore: no_leading_underscores_for_local_identifiers
    for (final _material in responseMain.data ?? []) {
      materialsCategory
          .add(MaterialMapper.materialGroupJsonToEntity(_material));
    }

    return materialsCategory;
  }
}
