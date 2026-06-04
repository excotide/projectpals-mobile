import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../constants/api_constants.dart';
import '../utils/token_storage.dart';

class ApiClient {
  static Dio? _dio;

  /// Dipasang ke `MaterialApp.navigatorKey` (main.dart) supaya interceptor bisa
  /// redirect ke `/login` saat token invalid (CLAUDE.md §Rule 3).
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Rule 3: token invalid → hapus token & arahkan ke /login.
          if (error.response?.statusCode == 401) {
            await TokenStorage.clearToken();
            final nav = navigatorKey.currentState;
            if (nav != null) {
              nav.pushNamedAndRemoveUntil('/login', (route) => false);
            }
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static void reset() => _dio = null;
}
