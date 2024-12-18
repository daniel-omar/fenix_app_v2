// Generated by https://quicktype.io

import 'package:fenix_app_v2/features/auth/domain/domain.dart';

class Product {
  int? idMaterial;
  String codigoMaterial;
  String nombreMaterial;
  String? descripcionMaterial;
  double precio;
  bool esSeriado;
  int? longitudSerie;
  int? idCategoria;
  User? user;

  Product({
    this.idMaterial,
    required this.codigoMaterial,
    required this.nombreMaterial,
    this.descripcionMaterial,
    required this.precio,
    required this.esSeriado,
    this.longitudSerie,
    this.idCategoria,
    this.user,
  });
}
