import 'package:flutter/material.dart';

class OrderClient {
  int idOrden;
  int idTipoDocumento;
  String numeroDocumento;
  String nombre;
  String apellidos;
  String numeroTelefono;
  String? numeroTelefono2;
  String? correo;
  String parenteso;

  OrderClient({
    required this.idOrden,
    required this.idTipoDocumento,
    required this.numeroDocumento,
    required this.nombre,
    required this.apellidos,
    required this.numeroTelefono,
    this.numeroTelefono2,
    this.correo,
    required this.parenteso,
  });

  Map<String, dynamic> toJson() => {
        "id_orden": idOrden,
        "id_tipo_documento": idTipoDocumento,
        "numero_documento": numeroDocumento,
        "nombre": nombre,
        "apellidos": apellidos,
        "numeroTelefono": numeroTelefono,
        "numeroTelefono2": numeroTelefono2,
        "correo": correo,
        "parenteso": parenteso
      };
}
