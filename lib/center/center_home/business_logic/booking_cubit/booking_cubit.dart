import 'package:attenda/center/center_appointments/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  static BookingCubit get(BuildContext context)=>BlocProvider.of<BookingCubit>(context);

  List<String> teachers = [];
  Future<void> searchTeacher(String teacherId) async {
    teachers=[];
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
}
