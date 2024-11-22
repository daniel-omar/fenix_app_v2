import 'package:fenix_app_v2/features/home/domain/domain.dart';

class MenuRepositoryImpl extends MenuRepository {
  final MenuDatasource datasource;

  MenuRepositoryImpl(this.datasource);

  @override
  Future<Menu> getMenuById(int idMenu) {
    return datasource.getMenuById(idMenu);
  }

  @override
  Future<List<Menu>> getMenusByUser(int idUsuario) {
    return datasource.getMenusByUser(idUsuario);
  }
}
