part of 'auth_cubit.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}
