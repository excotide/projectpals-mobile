import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

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
      final msg = e.response?.data?['message'] ?? 'Login failed';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
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
      final msg = e.response?.data?['message'] ?? 'Registration failed';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Logout failed';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to get user';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }
}
