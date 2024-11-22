import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/activity_category.dart';

class ActivityCategoryMapper {
  static ActivityCategory activityJsonToEntity(Map<String, dynamic> json) =>
      ActivityCategory(
        idCategoriaActividad: json["id_categoria_actividad"],
        nombreCategoriaActividad: json["nombre_categoria_actividad"],
      );
}
