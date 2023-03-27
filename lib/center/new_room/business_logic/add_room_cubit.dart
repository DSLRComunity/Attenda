import 'package:attenda/center/new_room/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_room_state.dart';

class AddRoomCubit extends Cubit<AddRoomState> {
  AddRoomCubit() : super(AddRoomInitial());

  static AddRoomCubit get(BuildContext context) =>
      BlocProvider.of<AddRoomCubit>(context);

  Future<void> addRoom(RoomModel room) async {
    emit(AddRoomLoad());
    await  FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('rooms')
        .doc(room.roomNum)
        .set(room.toJson()).then((value){
          emit(AddRoomSuccess());
    }).catchError((error){
      emit(AddRoomError(error.toString()));
    });
  }

}
