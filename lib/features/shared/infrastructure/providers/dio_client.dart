import 'package:dio/dio.dart';
import 'package:fenix_app_v2/config/constants/environment.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/auth_interceptor.dart';

class DioClient {
  DioClient() {
    addInterceptor(AuthInterceptor());
  }

  final Dio dio = Dio(
    BaseOptions(baseUrl: Environment.apiUrl),
  );

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}
