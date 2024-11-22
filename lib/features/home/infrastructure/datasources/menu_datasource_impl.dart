import 'package:dio/dio.dart';
import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/home/domain/domain.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/dio_client.dart';

import '../errors/menu_errors.dart';
import '../mappers/menu_mapper.dart';

class MenuDatasourceImpl extends MenuDatasource {
  late final dioClient = DioClient();

  MenuDatasourceImpl();

  @override
  Future<Menu> getMenuById(int idMenu) async {
    try {
      final response = await dioClient.dio.get('/menu/$idMenu');
      final product = MenuMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Menu>> getMenusByUser(int idUsuario) async {
    await Future.delayed(const Duration(milliseconds: 100));

    //final response = await dioClient.dio.get<List>('/permisos/$idUsuario');
    final List<Menu> menus = [];
    menus.add(
      Menu(
          idMenu: 1,
          codigoMenu: "0001",
          nombreMenu: "Materiales",
          descripcionMenu: "Materiales técnico",
          rutaMenu: "/materials"),
    );
    // for (final product in response.data ?? []) {
    //   products.add(MenuMapper.jsonToEntity(product));
    // }

    return menus;
  }
}
