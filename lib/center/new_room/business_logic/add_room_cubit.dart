import 'package:attenda/center/new_room/models/new_room_error.dart';
import 'package:attenda/center/new_room/models/new_room_model.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_room_state.dart';

class AddRoomCubit extends Cubit<AddRoomState> {
  AddRoomCubit() : super(AddRoomInitial());

  static AddRoomCubit get(BuildContext context) =>
      BlocProvider.of<AddRoomCubit>(context);

  Future<void> addRoom(NewRoomModel room, BuildContext context) async {
    if (await sl<ConnectionStatus>().isConnected(context)) {
   try{
     emit(AddRoomLoad());
     Response response=   await DioHelper.postData(path: EndPoints.addNewRoom, data: room.toJson(),);
     emit(AddRoomSuccess());
   }on DioError catch(error){
     if(error.response?.statusCode==422){
       NewRoomError errors = NewRoomError.fromJson(error.response?.data);
       if (errors.data.name != null) {
         emit(AddRoomError(errors.data.name!));
       }
       if (errors.data.size != null) {
         emit(AddRoomError(errors.data.size!));
       }
       if (errors.data.color != null) {
         emit(AddRoomError(errors.data.color!));
       }
     }else{
       emit(AddRoomError(error.response!.data));
       print(error.response.toString());
     }
     }
   }
    }
  }
