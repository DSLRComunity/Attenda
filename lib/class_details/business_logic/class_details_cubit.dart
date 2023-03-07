import 'package:attenda/students/models/student_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../classes/models/class_model.dart';
import '../../classes/view/widgets/get_day_function.dart';
import '../../students/models/students_model.dart';
part 'class_details_state.dart';

class ClassDetailsCubit extends Cubit<ClassDetailsState> {
  ClassDetailsCubit() : super(ClassDetailsInitial());

  static ClassDetailsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  int numOfAttendantStudents = 0;
  List<StudentsModel> classStudents = [];
  List<StudentsModel> classAttendantStudents = [];

  Future<void> getClassStudents(ClassModel currentClass) async {
    classStudents = [];
    emit(GetClassStudentsLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('classStudents')
        .get()
        .then((students) {
      students.docs.forEach((student) {
        classStudents.add(StudentsModel.fromJson(student.data()));
      });
      emit(GetClassStudentsSuccess());
      if (kDebugMode) {
        print(classStudents);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetClassStudentsError(error.toString()));
    });
  }

  Future<void> getClassAttendantStudents(ClassModel currentClass) async {
    classAttendantStudents = [];
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('attendantStudents')
        .get()
        .then((attendantStudents) {
      attendantStudents.docs.forEach((attendantStudent) {
        classAttendantStudents
            .add(StudentsModel.fromJson(attendantStudent.data()));
      });
      numOfAttendantStudents = classAttendantStudents.length;
      emit(state);
    }).catchError((error) {});
  }

  Future<void> addToAttendance(StudentsModel student, ClassModel currentClass) async {
    Map<String, dynamic> history = StudentHistory(
      comment: 'No Comment ',
      classDate: currentClass.date.toString(),
      className: getClassName(currentClass),
      costPurchased: currentClass.classPrice,
      hwDegree: '0',
      hwStatus: false,
      quizDegree: '0',
      quizStatus: 'لم يؤدي',
      name: student.name,
      id: student.id,
    ).toJson();

    emit(AddAttendantStudentLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('attendantStudents')
        .doc(student.id)
        .set(student.toJson())
        .then((value) async {
         await updateHistory(currentClass, student.id, history);
      numOfAttendantStudents++;
      emit(AddAttendantStudentSuccess());
    }).catchError((error) {
      emit(AddAttendantStudentError(error.toString()));
    });
  }

  Future<void> updateHistory(ClassModel currentClass, String studentId, Map<String, dynamic> history) async {
    await addHistoryToAttendantStudent(currentClass, studentId, history)
        .then((value) async {
      await getClassHistory(currentClass);
      await addHistoryToStudent(currentClass.date, studentId, history);
      emit(UpdateHistorySuccess());
    }).catchError((error) {});
  }

  Future<void> addHistoryToAttendantStudent(ClassModel currentClass, String studentId, Map<String, dynamic> history) async {
    emit(UpdateHistoryLoad());
    // for add and update
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('attendantStudents')
        .doc(studentId)
        .collection('history')
        .doc(currentClass.date.toString())
        .set(history)
        .then((value)async {
      emit(UpdateHistorySuccess());
    }).catchError((error) {
      emit(UpdateDetailsError(error.toString()));
    });
  }

  Future<void> addHistoryToStudent(DateTime date, String studentId, Map<String, dynamic> history) async {
    //for add and update
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(studentId)
          .collection('history')
          .doc(date.toString())
          .set(history);
    } catch (error) {}
  }

  Future<void> updateClassDetails(ClassModel currentClass) async {
    emit(UpdateDetailsLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .set(currentClass.toJson())
        .then((value) {
      emit(UpdateDetailsSuccess());
    }).catchError((error) {
      emit(UpdateDetailsError(error.toString()));
    });
  }

  List<StudentHistory> classHistory = [];
  Future<void> getClassHistory(ClassModel currentClass) async {
    classHistory = [];
    emit(GetClassHistoryLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    classAttendantStudents.forEach((student) async {
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(getClassName(currentClass))
          .collection('dates')
          .doc(currentClass.date.toString())
          .collection('attendantStudents')
          .doc(student.id)
          .collection('history')
          .get()
          .then((value) {
        value.docs.forEach((history) {
          classHistory.add(StudentHistory.fromJson(history.data()));
        });
        emit(GetClassHistorySuccess());
      }).catchError((error) {
        emit(GetClassHistoryError());
      });
    });
  }
}
