import 'package:fenix_app_v2/features/orders/domain/domain.dart';

class OrderMaterial {
  int idMaterial;
  int idCategoria;
  Material? material;
  String? serie;
  bool? esSeriado;
  int cantidad;

  OrderMaterial({
    required this.idMaterial,
    required this.idCategoria,
    this.material,
    this.serie,
    this.esSeriado,
    required this.cantidad,
  });

  Map<String, dynamic> toJson() => {
        "id_material": idMaterial,
        "serie": serie,
        "cantidad": cantidad,
      };
}

class OrderMaterialGroup {
  int idCategoria;
  MaterialCategory? category;
  List<OrderMaterial>? materials;

  OrderMaterialGroup(
      {required this.idCategoria, this.category, this.materials});
}
