class Material {
  int idMaterial;
  String codigoMaterial;
  String nombreMaterial;
  int? idCategoria;
  bool? esSeriado;
  int? longitudSerie;

  Material({
    required this.idMaterial,
    required this.codigoMaterial,
    required this.nombreMaterial,
    this.idCategoria,
    this.esSeriado,
    this.longitudSerie,
  });

  Map<String, dynamic> toJson() => {
        "id_material": idMaterial,
        "codigo_material": codigoMaterial,
        "nombre_material": nombreMaterial,
        "id_categoria": idCategoria,
        "es_seriado": esSeriado,
        "longitud_serie": longitudSerie
      };
}
