class ActivityCategory {
  int idCategoriaActividad;
  String nombreCategoriaActividad;

  ActivityCategory({
    required this.idCategoriaActividad,
    required this.nombreCategoriaActividad,
  });

  Map<String, dynamic> toJson() => {
        "id_categoria_actividad": idCategoriaActividad,
        "nombre_categoria_actividad": nombreCategoriaActividad,
      };
}
