import 'package:attenda/center/center_appointments/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  List<MyEvent> appointments = [];
  Future<void> getAppointments() async {
    appointments=[];
    emit(GetAppointmentsLoad());
    await FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appointments')
        .get()
        .then((myAppointments) {
      myAppointments.docs.forEach((appointment) {
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
