import 'package:attenda/center/center_appointments/models/event_model.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
part 'center_home_state.dart';

class CenterHomeCubit extends Cubit<CenterHomeState> {
  CenterHomeCubit() : super(CenterHomeInitial());

  static CenterHomeCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> logout(BuildContext context) async {
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try {
        emit(LogoutLoading());
        Response response = await DioHelper.putData(
          path: EndPoints.centerLogout,
        );
        if (response.statusCode == 200) {
          emit(LogoutSuccess());
        }
      } on DioError catch (error) {
        emit(LogoutError(error.response!.statusMessage.toString()));
      }
    }
  }

  List<MyBooking> appointments = [];
  Future<void> getAppointments(BuildContext context) async {
    emit(GetAppointmentsLoad());
    try {
      if (await sl<ConnectionStatus>().isConnected(context)) {
        appointments = [];
        Response response = await DioHelper.getData(
          path: EndPoints.allBooking,
        );
        if (response.statusCode == 200) {
          print(response.data);
          response.data['data'].forEach((appointment) {
            appointments.add(MyBooking.fromJson(appointment));
          });
          emit(GetAppointmentsSuccess());
        }
      }
    } on DioError catch (error) {
      emit(GetAppointmentsError(error.response!.data));
    }
  }

  List<Appointment> makeAppointment({required bool teacherView}) {
    List<Appointment> events = [];
    DateTime start;
    DateTime end;
    // String dayName;
    // String firstTwoLetters;
    appointments.forEach((element) {
      // dayName = DateFormat('EEEE').format(element.from);
      // firstTwoLetters = dayName.substring(0, 2).toUpperCase();
      start = DateTime.parse('${element.date} ${element.time}');
      end = DateTime.parse('${element.date} ${element.time}').add(Duration(hours: int.tryParse(element.duration)!));
      events.add(Appointment(
        startTime: start,
        endTime: end,
        color: Color(element.color),
        id: element.id,
        // subject: teacherView ? '' : element.teacherName,
      ));
      // recurrenceRule: ' FREQ=WEEKLY;INTERVAL=1;BYDAY=$firstTwoLetters;COUNT=${element.recursion}'));
    });
    return events;
  }
}
