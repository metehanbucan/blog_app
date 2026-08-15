part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  AuthSignUp({required this.name, required this.email, required this.password});
  final String name;
  final String email;
  final String password;
}
