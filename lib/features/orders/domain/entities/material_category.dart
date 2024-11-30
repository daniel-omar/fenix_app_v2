class MaterialCategory {
  int idCategoria;
  String nombreCategoria;

  MaterialCategory({required this.idCategoria, required this.nombreCategoria});

  Map<String, dynamic> toJson() => {
        "id_categoria_material": idCategoria,
        "nombre_categoria": nombreCategoria,
      };
}
