import '../entities/user_entity.dart';

abstract class AuthRepository {
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

  Future<UserEntity> getMe();
}
