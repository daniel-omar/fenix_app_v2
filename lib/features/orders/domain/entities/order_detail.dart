import 'package:flutter/material.dart';

class OrderDetail {
  int idOrden;
  int idMaterial;
  Material? material;
  int serie;
  int cantidad;

  OrderDetail({
    required this.idOrden,
    required this.idMaterial,
    this.material,
    required this.serie,
    required this.cantidad,
  });

  Map<String, dynamic> toJson() => {
        "id_orden": idOrden,
        "id_material": idMaterial,
        "serie": serie,
        "cantidad": cantidad
      };
}
