import 'package:attenda/center/rooms/models/room_model.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(RoomsInitial());

  static RoomsCubit get(BuildContext context) =>
      BlocProvider.of<RoomsCubit>(context);

  List<RoomModel> rooms = [];
  Future<void> getRooms(BuildContext context) async {
    rooms=[];
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try {
        emit(GetRoomsLoad());
        Response response = await DioHelper.getData(
            path: EndPoints.getRooms, data: null);
        if (response.statusCode == 200) {
          response.data['data'].forEach((room){
            rooms.add(RoomModel.fromJson(room));
          });
          emit(GetRoomsSuccess());
        }
      } on DioError catch (error) {
        print(error.response!.data);
        emit(GetRoomsError(error.toString()));
      }
    }
  }
}
