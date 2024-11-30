import 'package:dio/dio.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/material_category_mapper.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/entities/response_main.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/mappers/response_main_mapper.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/dio_client.dart';

class MaterialCategoryDatasourceImpl extends MaterialCategoryDatasource {
  late final dioClient = DioClient();

  MaterialCategoryDatasourceImpl();

  @override
  Future<MaterialCategory> getById(int idMaterialCategory) async {
    try {
      final response = await dioClient.dio
          .get('/materials/material_category/getById/$idMaterialCategory');

      ResponseMain responseMain =
          ResponseMainMapper.responseJsonToEntity(response.data);

      final materialCategory =
          MaterialCategoryMapper.materialCategoryJsonToEntity(
              responseMain.data);
      return materialCategory;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw OrderNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<MaterialCategory>> getAll() async {
    final response =
        await dioClient.dio.get('/materials/material_category/getAll');
    ResponseMain responseMain =
        ResponseMainMapper.responseJsonToEntity(response.data);

    final List<MaterialCategory> materialCategorys = [];

    // ignore: no_leading_underscores_for_local_identifiers
    for (final _materialCategory in responseMain.data ?? []) {
      materialCategorys.add(MaterialCategoryMapper.materialCategoryJsonToEntity(
          _materialCategory));
    }

    return materialCategorys;
  }
}
