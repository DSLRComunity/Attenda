import 'package:attenda/center/center_home/models/event_model.dart';
import 'package:attenda/center/center_register/models/center_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../new_room/models/room_model.dart';

part 'center_home_state.dart';

class CenterHomeCubit extends Cubit<CenterHomeState> {
  CenterHomeCubit() : super(CenterHomeInitial());

  static CenterHomeCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> logout() async {
    emit(LogoutLoading());
    await FirebaseAuth.instance.signOut().then((value) {
      emit(LogoutSuccess());
    });
  }

  CenterModel? centerData;
  Future<void> getCenterData() async {
    emit(GetCenterDataLoad());
    FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      centerData = CenterModel.fromJson(value.data()!);
      emit(GetCenterDataSuccess());
    }).catchError((error) {
      emit(GetCenterDataError(error.toString()));
    });
  }

  List<RoomModel> rooms = [];
  Future<void> getRooms() async {
    emit(GetRoomsLoad());
    rooms = [];
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

  List<String> teachers = [];
  Future<void> searchTeacher(String teacherId) async {
    emit(SearchForTeacherLoad());
    teachers = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('uId', isEqualTo: teacherId)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        teachers.add(value.docs[0].data()['firstName']);
      }
      emit(SearchForTeacherSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(SearchForTeacherError(error.toString()));
    });
  }

  Future<void> addAppointment(MyEvent appointment) async {
    emit(AddAppointmentLoad());
    await FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appointments')
        .add(appointment.toJson())
        .then((value) {
      emit(AddAppointmentSuccess());
    }).catchError((error) {
      emit(AddAppointmentError());
    });
  }

  List<MyEvent> appointments = [];
  Future<void> getAppointments() async {
    emit(GetAppointmentsLoad());
    await FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appointments')
        .get()
        .then((myAppointments) {
      myAppointments.docs.forEach((appointment) {
        print(appointment.data());
        appointments.add(MyEvent.fromJson(appointment.data()));
      });
      emit(GetAppointmentsSuccess());
    }).catchError((error) {
      emit(GetAppointmentsError(error.toString()));
    });
  }


  List<Appointment> makeAppointment({required bool teacherView}) {
    List<Appointment> events = [];
    String dayName;
    String firstTwoLetters;
   appointments.forEach((element) {
      dayName = DateFormat('EEEE').format(element.from);
      firstTwoLetters = dayName.substring(0, 2).toUpperCase();
      events.add(Appointment(
          startTime: element.from,
          endTime: element.to,
          color: Color(element.color),
          subject:teacherView?'': element.teacherName,
          recurrenceRule: ' FREQ=WEEKLY;INTERVAL=1;BYDAY=$firstTwoLetters;COUNT=${element.recursion}'));
    });
    return events;
  }

}
