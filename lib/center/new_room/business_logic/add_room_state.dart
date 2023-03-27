part of 'add_room_cubit.dart';

abstract class AddRoomState {}

class AddRoomInitial extends AddRoomState {}

class AddRoomLoad extends AddRoomState {}

class AddRoomSuccess extends AddRoomState {}

class AddRoomError extends AddRoomState {
  String error;
  AddRoomError(this.error);
}
