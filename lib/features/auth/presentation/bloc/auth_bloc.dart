import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/token_storage.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/get_me_usecase.dart';
import '../../../auth/domain/usecases/login_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../auth/domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetMeUseCase getMeUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getMeUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final hasToken = await TokenStorage.hasToken();
    if (!hasToken) {
      emit(AuthUnauthenticated());
      return;
    }
    try {
      final user = await getMeUseCase();
      emit(AuthAuthenticated(user));
    } catch (_) {
      await TokenStorage.clearToken();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      final user = _parseUser(result['user']);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailure('Login failed: no user data returned'));
      }
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(AuthFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await registerUseCase(
        name: event.name,
        username: event.username,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );
      final user = _parseUser(result['user']);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailure('Registration failed: no user data returned'));
      }
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(AuthFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await logoutUseCase();
    } catch (_) {}
    emit(AuthUnauthenticated());
  }

  UserEntity? _parseUser(dynamic userJson) {
    if (userJson == null) return null;
    final u = userJson as Map<String, dynamic>;
    return UserEntity(
      id: u['id'] as int,
      name: u['name'] as String,
      username: u['username'] as String,
      email: u['email'] as String,
    );
  }
}
