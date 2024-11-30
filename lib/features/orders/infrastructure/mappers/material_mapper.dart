import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/material.dart';

class MaterialMapper {
  static Material materialJsonToEntity(Map<String, dynamic> json) => Material(
        idMaterial: json["id_material"],
        codigoMaterial: json["codigo_material"],
        nombreMaterial: json["nombre_material"],
        idCategoria: json["id_categoria_material"],
        esSeriado: json["esSeriado"],
      );
}
