part of 'user_management_cubit.dart';

abstract class UserManagementState {}

final class UserManagementInitial extends UserManagementState {}

final class UserManagementLoading extends UserManagementState {}

final class UserManagementSuccess extends UserManagementState {}

final class UserManagementError extends UserManagementState {
  String error;
  UserManagementError(this.error);
}
