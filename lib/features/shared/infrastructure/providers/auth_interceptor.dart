import 'package:dio/dio.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

class AuthInterceptor implements Interceptor {
  final KeyValueStorageService keyValueStorageService =
      KeyValueStorageServiceImpl();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['is_auth']) {
      return handler.next(options);
    }

    final token = await keyValueStorageService.getValue<String>('token');
    options.headers.addAll({"Authorization": "$token"});

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // navigate to the authentication screen
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: 'The user has been deleted or the session is expired',
        ),
      );
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = response.data;
    if (responseData is Map) {
      return handler.next(response);
    }
    return handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        error: 'The response is not in valid format',
      ),
    );
  }
}
