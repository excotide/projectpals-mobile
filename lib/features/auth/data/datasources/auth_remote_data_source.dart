import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Ambil pesan error yang berarti dari DioException.
/// Membedakan error koneksi (mis. CORS di web / tidak ada internet) dari
/// error yang dikirim server, dan aman terhadap body non-JSON.
String _dioMessage(DioException e, String fallback) {
  final data = e.response?.data;
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet '
          '(atau CORS bila dijalankan di web).';
    default:
      return fallback;
  }
}

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String deviceName = 'mobile',
  });

  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String deviceName = 'mobile',
  });

  Future<void> logout();

  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String deviceName = 'mobile',
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(
          message: _dioMessage(e, 'Login failed'),
          statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String deviceName = 'mobile',
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'device_name': deviceName,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(
          message: _dioMessage(e, 'Registration failed'),
          statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw ServerException(
          message: _dioMessage(e, 'Logout failed'),
          statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
          message: _dioMessage(e, 'Failed to get user'),
          statusCode: e.response?.statusCode);
    }
  }
}
