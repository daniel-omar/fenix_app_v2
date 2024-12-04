import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/material.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/material_category.dart';

class MaterialMapper {
  static Material materialJsonToEntity(Map<String, dynamic> json) => Material(
        idMaterial: json["id_material"],
        codigoMaterial: json["codigo_material"],
        nombreMaterial: json["nombre_material"],
        idCategoria: json["id_categoria_material"],
        esSeriado: json["es_seriado"],
      );

  static MaterialCategory materialGroupJsonToEntity(Map<String, dynamic> json) {
    var list = json['materiales'] as List;
    List<Material> itemsList =
        list.map((i) => MaterialMapper.materialJsonToEntity(i)).toList();

    return MaterialCategory(
        idCategoria: json["id_categoria_material"],
        nombreCategoria: json["nombre_categoria_material"],
        materiales: itemsList);
  }
}
