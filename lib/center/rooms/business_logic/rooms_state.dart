part of 'rooms_cubit.dart';

abstract class RoomsState {}

class RoomsInitial extends RoomsState {}

class GetRoomsLoad extends RoomsState {}

class GetRoomsSuccess extends RoomsState {}

class GetRoomsError extends RoomsState {
  String error;
  GetRoomsError(this.error);
}
