import 'package:fenix_app_v2/features/auth/domain/domain.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/entities/response_main.dart';

class ResponseMainMapper {
  static ResponseMain responseJsonToEntity(Map<String, dynamic> json) =>
      ResponseMain(
          status: json["status"], data: json["data"], message: json["message"]);
}
