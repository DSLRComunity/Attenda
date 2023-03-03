import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/students_model.dart';

part 'add_student_state.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  AddStudentCubit() : super(AddStudentInitial());

  static AddStudentCubit get(BuildContext context) => BlocProvider.of(context);


  Future<void> addStudent(StudentsModel student) async {
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
}
