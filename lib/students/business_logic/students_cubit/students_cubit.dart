import 'package:attenda/students/models/student_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/students_model.dart';

part 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  StudentsCubit() : super(StudentsInitial());

  static StudentsCubit get(BuildContext context)=>BlocProvider.of(context);

  List<StudentsModel>?students=[];
  Future<void> getAllStudents()async{
    students=[];
    emit(GetStudentsLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students').get().then((allStudents){
          allStudents.docs.forEach((student) {
            students?.add(StudentsModel.fromJson(student.data()));
          });
          emit(GetStudentsSuccess());
    }).catchError((error){
      emit(GetStudentsError(error.toString()));
    });

  }

  Future<void> editStudentInfo(StudentsModel student)async{
    emit(UpdateStudentLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students')
        .doc(student.id)
        .set(student.toJson())
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
    }).catchError((error){
      emit(GetStudentHistoryError(error.toString()));
    });
  }
}
