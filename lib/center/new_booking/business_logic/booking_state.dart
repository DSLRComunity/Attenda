part of 'booking_cubit.dart';


abstract class BookingState {}

class BookingInitial extends BookingState {}

class SearchForTeacherLoad extends BookingState {}

class SearchForTeacherSuccess extends BookingState {}

class SearchForTeacherError extends BookingState {
  String error;
  SearchForTeacherError(this.error);
}

class GetMyRoomsLoad extends BookingState {}

class GetMyRoomsSuccess extends BookingState {}

class GetMyRoomsError extends BookingState {
  String error;
  GetMyRoomsError(this.error);
}

class AddAppointmentLoad extends BookingState {}

class AddAppointmentSuccess extends BookingState {}

class AddAppointmentError extends BookingState {
  String error;
  AddAppointmentError(this.error);
}
