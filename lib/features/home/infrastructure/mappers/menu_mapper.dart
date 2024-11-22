import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/auth/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/home/domain/domain.dart';

class MenuMapper {
  static jsonToEntity(Map<String, dynamic> json) => Menu(
        idMenu: json["id_menu"],
        codigoMenu: json["codigo_menu"],
        nombreMenu: json["nombre_menu"],
        descripcionMenu: json["descripcion_menu"],
        rutaMenu: json["ruta_menu"],
      );
}
