import 'package:attenda/history/models/history_model.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/students/models/student_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../classes/models/class_model.dart';
import '../../classes/view/widgets/get_day_function.dart';
import '../../students/models/students_model.dart';
part 'class_details_state.dart';

class ClassDetailsCubit extends Cubit<ClassDetailsState> {
  ClassDetailsCubit() : super(ClassDetailsInitial());

  static ClassDetailsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  double totalMoney = 0;
  int classAttendants = 0;

  List<StudentsModel> classStudents = [];
  List<StudentsModel> classAttendantStudents = [];
  Future<void> updateClassDetails(ClassModel currentClass) async  {
    emit(UpdateDetailsLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass)).collection('dates').doc(currentClass.date.toString())
        .update({
      'centerName':currentClass.centerName,
      'classPrice':currentClass.classPrice,
      'maxHwDegree':currentClass.maxHwDegree,
      'maxQuizDegree':currentClass.maxQuizDegree,
    })
        .then((value) {
      emit(UpdateDetailsSuccess());
    }).catchError((error) {
      emit(UpdateDetailsError(error.toString()));
    });
  }
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
        classAttendantStudents.add(StudentsModel.fromJson(attendantStudent.data()));
      });
      emit(state);
    }).catchError((error) {});
  }

  bool checkAttendance(String studentId){
    bool valid = true;
    classHistory.forEach((element){
      if (element.id == studentId){
        valid = false;
      }
    });
    return valid;
  }
  Future<void> addToAttendance(StudentsModel student, ClassModel currentClass,BuildContext context) async {
    if (checkAttendance(student.id)) {
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
        parentPhone: student.parentPhone,
        parentName: student.parentName,
        gender: 'Male',
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
        await addHistory(currentClass, student.id, history,context);
        emit(AddAttendantStudentSuccess());
      }).catchError((error) {
        emit(AddAttendantStudentError(error.toString()));
      });
    }
  }

  Future<void> addHistory(ClassModel currentClass, String studentId, Map<String, dynamic> history,BuildContext context) async {
    await addHistoryToClass(currentClass, studentId, history).then((value) async {
      classHistory.add(StudentHistory.fromJson(history));
      emit(UpdateHistorySuccess());
      await addHistoryToStudent(currentClass.date, studentId, history);
      await addToAttendanceHistory(HistoryModel(
        userName: HomeCubit.get(context).userData!.firstName!,
        message: 'has register student with id ${studentId} as attendant in class ${getClassName(currentClass)} on ${DateFormat('yyyy-MM-dd').format(currentClass.date)} ',
            date: DateFormat.yMEd()
          .add_jms()
          .format(DateTime.now()),));
    }).catchError((error) {
      emit(UpdateHistoryError(error.toString()));
    });
  }

  Future<void> addHistoryToClass(ClassModel currentClass, String studentId, Map<String, dynamic> history) async {
    emit(UpdateHistoryLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(studentId)
        .set(history)
        .then((value) async {
      emit(UpdateHistorySuccess());
    }).catchError((error) {
      emit(UpdateDetailsError(error.toString()));
    });
  }

  Future<void> addHistoryToStudent(DateTime date, String studentId, Map<String, dynamic> history) async {
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

  Future<void> removeFromAttendance(String studentId, ClassModel currentClass,BuildContext context) async {
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
        .doc(studentId)
        .delete()
        .then((value) async {
      await removeHistory(currentClass, studentId,context);
      emit(AddAttendantStudentSuccess());
    }).catchError((error) {
      emit(AddAttendantStudentError(error.toString()));
    });
  }

  Future<void> removeHistory(ClassModel currentClass, String studentId,BuildContext context) async {
    await removeHistoryFromClass(currentClass, studentId).then((value) async {
      classHistory.removeWhere((element) => element.id == studentId);
      emit(UpdateHistorySuccess());
      await removeHistoryFromStudent(currentClass.date, studentId);
      await addToAttendanceHistory(HistoryModel(
        userName: HomeCubit.get(context).userData!.firstName!,
        message: 'has unregister student with id ${studentId} from attendance in class ${getClassName(currentClass)} on ${DateFormat('yyyy-MM-dd').format(currentClass.date)} ',
        date: DateFormat.yMEd()
            .add_jms()
            .format(DateTime.now()),));
    }).catchError((error) {
      emit(UpdateHistoryError(error.toString()));
    });
  }

  Future<void> removeHistoryFromClass(ClassModel currentClass, String studentId) async {
    emit(UpdateHistoryLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(studentId)
        .delete()
        .then((value) {
      emit(UpdateHistorySuccess());
    }).catchError((error) {
      emit(UpdateDetailsError(error.toString()));
    });
  }

  Future<void> removeHistoryFromStudent(DateTime date, String studentId) async {
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(studentId)
          .collection('history')
          .doc(date.toString())
          .delete();
    } catch (error) {}
  }

  List<StudentHistory> classHistory = [];

  Future<void> getClassHistory(ClassModel currentClass) async {
    classHistory = [];
    emit(GetClassHistoryLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .get()
        .then((value) {
      value.docs.forEach((history) {
        classHistory.add(StudentHistory.fromJson(history.data()));
      });
      emit(GetClassHistorySuccess());
    }).catchError((error) {
      emit(GetClassHistoryError());
    });
  }

  Future<void> updateQuizStatus(String id, String quizStatus, ClassModel currentClass) async {
    emit(UpdateHistoryLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(id)
        .update({'quizStatus': quizStatus}).then((value) async {
      emit(UpdateHistorySuccess());
    });
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('students')
        .doc(id)
        .collection('history')
        .doc(currentClass.date.toString())
        .update({'quizStatus': quizStatus});
  }

  Future<void> updateQuizDegree(String id, String quizDegree, ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(id)
        .update({'quizDegree': quizDegree}).then((value) async {
      emit(UpdateHistorySuccess());
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(id)
          .collection('history')
          .doc(currentClass.date.toString())
          .update({'quizDegree': quizDegree});
    });
  }

  Future<void> updateHwStatus(String id, dynamic hwStatus, ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(id)
        .update({'hwStatus': hwStatus}).then((value) async {
      emit(UpdateHistorySuccess());
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(id)
          .collection('history')
          .doc(currentClass.date.toString())
          .update({'hwStatus': hwStatus});
    });
  }

  Future<void> updateHwDegree(String id, String hwDegree, ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(id)
        .update({'hwDegree': hwDegree}).then((value) async {
      emit(UpdateHistorySuccess());
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(id)
          .collection('history')
          .doc(currentClass.date.toString())
          .update({'hwDegree': hwDegree});
    });
  }

  Future<void> updateComment(String id, String comment, ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(id)
        .update({'comment': comment}).then((value) async {
      emit(UpdateHistorySuccess());
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(id)
          .collection('history')
          .doc(currentClass.date.toString())
          .update({'comment': comment});
    });
  }

  Future<void> updateCost(String id, double cost, ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .collection('histories')
        .doc(id)
        .update({'cost': cost}).then((value) async {
      emit(UpdateHistorySuccess());
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('students')
          .doc(id)
          .collection('history')
          .doc(currentClass.date.toString())
          .update({'cost': cost});
    });
  }

  Future<void> getTotalMoney(ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .get()
        .then((value) {
      totalMoney = value.data()!['moneyCollected'];
      emit(GetTotalMoney());
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> getClassAttendantsNum(ClassModel currentClass) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .doc(getClassName(currentClass))
        .collection('dates')
        .doc(currentClass.date.toString())
        .get()
        .then((value) {
      classAttendants = value.data()!['numOfAttendants'];
      emit(GetTotalAttendants());
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> updateNumOfAttendants(ClassModel currentClass) async {
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(getClassName(currentClass))
          .collection('dates')
          .doc(currentClass.date.toString())
          .update({'numOfAttendants': classAttendants});
    } catch (error) {}
  }

  Future<void> updateMoneyCollected(ClassModel currentClass) async {
    try {
      FirebaseFirestore instance = FirebaseFirestore.instance;
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(getClassName(currentClass))
          .collection('dates')
          .doc(currentClass.date.toString())
          .update({'moneyCollected': totalMoney});
    } catch (error) {}
  }

  Future<void>addToAttendanceHistory(HistoryModel history)async{
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('attendanceHistory')
          .doc()
          .set(history.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

}
