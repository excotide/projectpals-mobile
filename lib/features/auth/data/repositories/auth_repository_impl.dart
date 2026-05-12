import '../../../../core/utils/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String deviceName = 'mobile',
  }) async {
    final result = await remoteDataSource.login(
      email: email,
      password: password,
      deviceName: deviceName,
    );
    if (result['token'] != null) {
      await TokenStorage.saveToken(result['token'] as String);
    }
    return result;
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
    final result = await remoteDataSource.register(
      name: name,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      deviceName: deviceName,
    );
    if (result['token'] != null) {
      await TokenStorage.saveToken(result['token'] as String);
    }
    return result;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await TokenStorage.clearToken();
  }

  @override
  Future<UserEntity> getMe() => remoteDataSource.getMe();
}
