import 'package:attenda/history/models/history_model.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/students_model.dart';
import 'package:intl/intl.dart';
part 'add_student_state.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  AddStudentCubit() : super(AddStudentInitial());

  static AddStudentCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> addStudent(StudentsModel student,BuildContext context) async {
    emit(AddStudentLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students')
        .doc(student.id)
        .set(student.toJson())
        .then((value) {
      emit(AddStudentSuccess());
      addStudentToChoosedClass(student);
      addToManageHistory(HistoryModel(userName: HomeCubit.get(context).userData!.firstName!,
        message: 'has added a new student with id ${student.id}, name ${student.name} and phone number ${student.phone} at class ${student.className} '
        , date:  DateFormat.yMEd()
          .add_jms()
          .format(DateTime.now()),));
    }).catchError((error) {
      emit(AddStudentError(error.toString()));
    });
  }

  void addStudentToChoosedClass(StudentsModel student) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(student.className)
          .collection('classStudents')
          .doc(student.id)
          .set(student.toJson());
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addToManageHistory(HistoryModel history) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('manageHistory')
          .doc()
          .set(history.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }
}
