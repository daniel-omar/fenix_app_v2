import 'package:fenix_app_v2/features/orders/domain/entities/material.dart';

class MaterialCategory {
  int idCategoria;
  String nombreCategoria;
  List<Material>? materiales;

  MaterialCategory(
      {required this.idCategoria,
      required this.nombreCategoria,
      this.materiales});

  Map<String, dynamic> toJson() => {
        "id_categoria_material": idCategoria,
        "nombre_categoria": nombreCategoria,
      };
}
