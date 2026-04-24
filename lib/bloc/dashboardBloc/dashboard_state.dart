part of 'dashboard_cubit.dart';

abstract class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardSuccessState extends DashboardState {}

final class DashboardErrorState extends DashboardState {
  String error;

  DashboardErrorState(this.error);
}
