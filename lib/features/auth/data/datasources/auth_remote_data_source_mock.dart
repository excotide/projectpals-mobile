import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// ─────────────────────────────────────────────────────────────
/// MOCK — hanya untuk development tanpa backend.
/// Ganti di main.dart:
///   remoteDataSource: AuthRemoteDataSourceMock()
/// Kalau backend sudah siap, kembalikan ke:
///   remoteDataSource: AuthRemoteDataSourceImpl(dio: dio)
/// ─────────────────────────────────────────────────────────────
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  // Dummy user yang akan selalu "login"
  static const _dummyToken = 'mock-token-123';
  static final _dummyUser = UserModel(
    id: 1,
    name: 'Ambar Singa',
    username: 'ambasing',
    email: 'ambar@projectpals.dev',
  );

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String deviceName = 'mobile',
  }) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'token': _dummyToken,
      'user': {
        'id': _dummyUser.id,
        'name': _dummyUser.name,
        'username': _dummyUser.username,
        'email': _dummyUser.email,
      },
    };
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
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'token': _dummyToken,
      'user': {
        'id': 1,
        'name': name,
        'username': username,
        'email': email,
      },
    };
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Tidak perlu melakukan apa-apa
  }

  @override
  Future<UserModel> getMe() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyUser;
  }
}