import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/material_category.dart';

class MaterialCategoryMapper {
  static MaterialCategory materialCategoryJsonToEntity(
          Map<String, dynamic> json) =>
      MaterialCategory(
        idCategoria: json["id_categoria_material"],
        nombreCategoria: json["nombre_categoria"],
      );
}
