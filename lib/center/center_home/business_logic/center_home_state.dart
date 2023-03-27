part of 'center_home_cubit.dart';

abstract class CenterHomeState {}

class CenterHomeInitial extends CenterHomeState {}

class LogoutLoading extends CenterHomeState {}

class LogoutSuccess extends CenterHomeState {}

class LogoutError extends CenterHomeState {}

class GetCenterDataLoad extends CenterHomeState {}

class GetCenterDataSuccess extends CenterHomeState {}

class GetCenterDataError extends CenterHomeState {
  String error;
  GetCenterDataError(this.error);
}

class GetRoomsLoad extends CenterHomeState {}

class GetRoomsSuccess extends CenterHomeState {}

class GetRoomsError extends CenterHomeState {
  String error;
  GetRoomsError(this.error);
}

class SearchForTeacherLoad extends CenterHomeState {}

class SearchForTeacherSuccess extends CenterHomeState {}

class SearchForTeacherError extends CenterHomeState {
  String error;
  SearchForTeacherError(this.error);
}

class AddAppointmentLoad extends CenterHomeState {}

class AddAppointmentSuccess extends CenterHomeState {}

class AddAppointmentError extends CenterHomeState {}

class GetAppointmentsLoad extends CenterHomeState {}

class GetAppointmentsSuccess extends CenterHomeState {}

class GetAppointmentsError extends CenterHomeState {
  String error;
  GetAppointmentsError(this.error);
}