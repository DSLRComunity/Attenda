import 'package:attenda/history/models/history_model.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/students/models/student_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/students_model.dart';

part 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  StudentsCubit() : super(StudentsInitial());

  static StudentsCubit get(BuildContext context) => BlocProvider.of(context);

  List<StudentsModel>? students = [];

  Future<void> getAllStudents() async {
    students = [];
    emit(GetStudentsLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students')
        .get()
        .then((allStudents) {
      allStudents.docs.forEach((student) {
        students?.add(StudentsModel.fromJson(student.data()));
      });
      emit(GetStudentsSuccess());
    }).catchError((error) {
      emit(GetStudentsError(error.toString()));
    });
  }

  Future<void> editStudentInfo(StudentsModel student) async {
    emit(UpdateStudentLoad());
    print(student.toJson());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students')
        .doc(student.id)
        .update(student.toJson())
        .then((value) async {
      await addStudentToChoosedClass(student);
      emit(UpdateStudentSuccess());
    }).catchError((error) {
      emit(UpdateStudentError(error.toString()));
    });
  }

  Future<void> addStudentToChoosedClass(StudentsModel student) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(student.className)
          .collection('classStudents')
          .doc(student.id)
          .set(student.toJson());
    } catch (error) {}
  }

  List<StudentHistory> studentHistory = [];

  Future<void> getStudentHistory(String id) async {
    studentHistory = [];
    emit(GetStudentHistoryLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students')
        .doc(id)
        .collection('history')
        .get()
        .then((allHistory) {
      allHistory.docs.forEach((history) {
        studentHistory.add(StudentHistory.fromJson(history.data()));
      });
      emit(GetStudentHistorySuccess());
    }).catchError((error) {
      emit(GetStudentHistoryError(error.toString()));
    });
  }

  Future<void> changeStudentClass(
      String oldClass, String newClass, StudentsModel student) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('classes');
    await collectionReference
        .doc(oldClass)
        .collection('classStudents')
        .doc(student.id)
        .delete();
    await collectionReference
        .doc(newClass)
        .collection('classStudents')
        .doc(student.id)
        .set(student.toJson());
  }

  Future<void> addToManageHistory(HistoryModel history) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('manageHistory')
          .doc()
          .set(history.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> removeStudent(String studentId, String className, BuildContext context) async {
    emit(DeleteStudentLoad());
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('students')
            .doc(studentId);
    await documentReference
        .collection('history')
        .get()
        .then((studentHistories) async {
      studentHistories.docs.forEach((studentHistory) async {
        await documentReference
            .collection('history')
            .doc(studentHistory.id)
            .delete();
      });
      await documentReference.delete();
      students!.removeWhere((element) => element.id == studentId);
      emit(DeleteStudentSuccess());
      await addToManageHistory(HistoryModel(
        userName: HomeCubit.get(context).userData!.firstName!,
        message: 'has removed a student whose id $studentId from our students ',
        date: DateFormat.yMEd().add_jms().format(DateTime.now()),
      ));
    }).catchError((error) {
      emit(DeleteStudentError(error.toString()));
    });

    if (className != "") {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(className)
          .collection('classStudents')
          .doc(studentId)
          .delete();
    }
  }
}
