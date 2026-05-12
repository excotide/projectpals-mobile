import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return repository.register(
      name: name,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
