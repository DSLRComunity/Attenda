part of 'center_home_cubit.dart';

abstract class CenterHomeState {}

class CenterHomeInitial extends CenterHomeState {}

class LogoutLoading extends CenterHomeState {}

class LogoutSuccess extends CenterHomeState {}

class LogoutError extends CenterHomeState {
  String error;
  LogoutError(this.error);
}

class GetAppointmentsLoad extends CenterHomeState {}

class GetAppointmentsSuccess extends CenterHomeState {}

class GetAppointmentsError extends CenterHomeState {
  String error;
  GetAppointmentsError(this.error);
}
