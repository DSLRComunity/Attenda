import 'package:attenda/center/new_room/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(RoomsInitial());
  static RoomsCubit get(BuildContext context)=>BlocProvider.of<RoomsCubit>(context);

  List<RoomModel> rooms = [];
  Future<void> getRooms() async {
    rooms = [];
    emit(GetRoomsLoad());
    await FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('rooms')
        .get()
        .then((currentRooms) {
      currentRooms.docs.forEach((room) {
        rooms.add(RoomModel.fromJson(room.data()));
      });
      emit(GetRoomsSuccess());
    }).catchError((error) {
      emit(GetRoomsError(error.toString()));
    });
  }
}
