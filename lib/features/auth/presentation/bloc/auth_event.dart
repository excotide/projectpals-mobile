part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  RegisterRequested({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}

class LogoutRequested extends AuthEvent {}
