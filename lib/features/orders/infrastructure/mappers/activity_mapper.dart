import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/activity.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/activity_category.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/mappers/activity_category_mapper.dart';

class ActivityMapper {
  static activityJsonToEntity(Map<String, dynamic> json) => Activity(
        idActividad: json["id_actividad"],
        nombreActividad: json["nombre_actividad"],
        categoriaActividad: ActivityCategoryMapper.activityJsonToEntity(
            json["categoria_actividad"]),
      );
}
