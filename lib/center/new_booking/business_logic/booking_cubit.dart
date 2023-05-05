import 'package:attenda/center/new_booking/models/new_booking_model.dart';
import 'package:attenda/center/new_booking/models/teacher_model.dart';
import 'package:attenda/center/rooms/models/room_model.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  static BookingCubit get(BuildContext context)=>BlocProvider.of<BookingCubit>(context);

List<MyTeacherModel> searchedTeacher=[];
  Future<void> searchTeacher(String teacherId,BuildContext context) async {
    emit(SearchForTeacherLoad());
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try{
        final Response response=await DioHelper.getData(path:EndPoints.searchForTeacher,queryParameters: {'uuid':teacherId});
        if(response.statusCode==200){
          searchedTeacher=[MyTeacherModel.fromJson(response.data['data'])];
          emit(SearchForTeacherSuccess());
        }
      }on DioError catch(error){
        emit(SearchForTeacherError(error.response!.data));
      }
    }
    }


   static const  _pageSize = 10;
  final PagingController<int, MyTeacherModel> teacherPagingController = PagingController(firstPageKey: 1);
  Future<void>getMyTeachers(BuildContext context,int pageKey)async{
    if(await sl<ConnectionStatus>().isConnected(context)){
    try{
      final Response response =await DioHelper.getData(path: EndPoints.myTeachers);
      if(response.statusCode==200){
        List<MyTeacherModel>list=[];
        response.data['data']['data'].forEach((teacher){
          list.add(MyTeacherModel.fromJson(teacher));
        });
        final isLastPage = response.data['data']['data'].length < _pageSize;
        if (isLastPage) {
          teacherPagingController.appendLastPage(list);
        } else {
          final num  nextPageKey = pageKey + 1;
          teacherPagingController.appendPage(list, nextPageKey as int);
        }
      }
    }catch(error){
      teacherPagingController.error=error.toString();
    }
    }
  }

  List<RoomModel> rooms = [];
  Future<void> getMyRooms(BuildContext context) async {
    rooms=[];
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try {
        emit(GetMyRoomsLoad());
        Response response = await DioHelper.getData(
            path: EndPoints.getRooms,);
        if (response.statusCode == 200) {
          print(response.data);
          response.data['data'].forEach((room){
            rooms.add(RoomModel.fromJson(room));
            print(rooms);
          });
          emit(GetMyRoomsSuccess());
        }
      } on DioError catch (error) {
        print(error.response!.data);
        emit(GetMyRoomsError(error.toString()));
      }
    }
  }

  Future<void> addAppointment(NewBooking appointment,BuildContext context) async {
    emit(AddAppointmentLoad());
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try{
        final Response response=await DioHelper.postData(path: EndPoints.bookRoom, data: appointment.toJson());
        if(response.statusCode==200){
          emit(AddAppointmentSuccess());
        }
      }on DioError catch(error){
        print(error.response!.data);
        emit(AddAppointmentError(error.response!.data));
      }
    }
  }
}
