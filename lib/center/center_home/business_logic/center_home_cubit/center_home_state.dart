part of 'center_home_cubit.dart';

abstract class CenterHomeState {}

class CenterHomeInitial extends CenterHomeState {}

class LogoutLoading extends CenterHomeState {}

class LogoutSuccess extends CenterHomeState {}

class LogoutError extends CenterHomeState {}

class GetRoomsLoad extends CenterHomeState {}

class GetRoomsSuccess extends CenterHomeState {}

class GetRoomsError extends CenterHomeState {
  String error;
  GetRoomsError(this.error);
}

class GetAppointmentsLoad extends CenterHomeState {}

class GetAppointmentsSuccess extends CenterHomeState {}

class GetAppointmentsError extends CenterHomeState {
  String error;
  GetAppointmentsError(this.error);
}