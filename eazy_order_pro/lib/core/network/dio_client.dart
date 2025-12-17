
import 'package:eazy_order_pro/feature/auth/applications/login_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eazy_order_pro/core/config/api_config.dart';

class DioClient {
  late Dio dio;
  final Ref ref;

  // Common headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'x-api-version': ApiConfig.apiVersion,
  };

  DioClient(this.ref) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        contentType: "application/json",
        headers: headers,
        validateStatus:  (status) {
          if (status != null) {
            return true;
          }
          return false;
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            _handleUnAuthorized();
          }
          return handler.next(response);
        },
        onError: (DioException err, handler) {
          if (err.response?.statusCode == 401) {
            _handleUnAuthorized();
          }
          return handler.next(err);
        },
      ),
    );
  }

  void _handleUnAuthorized() {
    ref.read(loginControllerProvider.notifier).logout();
  }
}

// Dio client provider
final dioClientProvider = Provider((ref) => DioClient(ref));
