import 'package:fenix_app_v2/features/orders/domain/entities/activity_category.dart';

class Activity {
  int idActividad;
  String nombreActividad;
  ActivityCategory categoriaActividad;

  Activity({
    required this.idActividad,
    required this.nombreActividad,
    required this.categoriaActividad,
  });

  Map<String, dynamic> toJson() => {
        "id_actividad": idActividad,
        "nombre_actividad": nombreActividad,
        "categoria_actividad": categoriaActividad.toJson(),
      };
}
