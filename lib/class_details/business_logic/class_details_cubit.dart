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

  List<StudentsModel> classStudents = [];

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

  Future<void> addToAttendance(StudentsModel student, ClassModel currentClass) async {
    Map<String, dynamic> history = StudentHistory(
            comment: ' ',
            classDate: currentClass.date.toString(),
            className: getClassName(currentClass),
            costPurchased: currentClass.classPrice,
            hwDegree: '0',
            hwStatus: 'لم يؤدي',
            quizDegree: '0',
            quizStatus: 'لم يؤدي')
        .toJson();

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
      await addHistoryToAttendantStudent(currentClass, student.id, history);
      emit(AddAttendantStudentSuccess());
    }).catchError((error) {
      emit(AddAttendantStudentError(error.toString()));
    });
    await addHistoryToStudent(currentClass.date, student.id, history);
  }

  Future<void>updateHistory(ClassModel currentClass,StudentsModel student,Map<String,dynamic>history)async{
   await addHistoryToAttendantStudent(currentClass, student.id, history).then((value){

   });
  }

  Future<void> addHistoryToAttendantStudent(ClassModel currentClass, String studentId, Map<String, dynamic> history) async {
    emit(UpdateDetailsLoad());
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
        .set(history).then((value){
          emit(UpdateHistorySuccess());
    }).catchError((error){
emit(UpdateDetailsError(error.toString()));
    });
  }
  Future<void> addHistoryToStudent(DateTime date, String studentId, Map<String, dynamic> history) async {
    //for add and update
   try{
     FirebaseFirestore instance = FirebaseFirestore.instance;
     await instance
         .collection('users')
         .doc(FirebaseAuth.instance.currentUser!.uid)
         .collection('students')
         .doc(studentId)
         .collection('history')
         .doc(date.toString())
         .set(history);
   }catch(error){}
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

  Future<void> updateAttendantStudentHistory() async {}

//
//   void editStudentAttendance(ClassModel currentClass, StudentsModel student,
//       DateTime classDate, BuildContext context) async {
//     emit(AddAttendantStudentLoad());
//     try {
//       //update student history
//       var studentHistoryBox = sl<Box<StudentHistory>>();
//       StudentHistory studentRecord = StudentHistory(
//           comment: '-',
//           classDate: classDate.toString(),
//           costPurchased: 0.0,
//           degree: '',
//           hwDegree: '',
//           hwStatus: false,
//           quizDegree: '',
//           quizStatus: false);
//       var key = await studentHistoryBox.add(studentRecord);
//       var studentHistoryObject = studentHistoryBox.get(key);
//
//       //update student
//       var box = sl<Box<StudentsModel>>();
//       List<StudentsModel> requiredStudent =
//           box.values.where((element) => element == student).toList();
//       print(requiredStudent);
//       requiredStudent[0].studentHistory![classDate.toString()] =
//           studentHistoryObject!;
//       await requiredStudent[0].save();
//       // update class
//       getClassStudents(currentClass, context);
//       // List<StudentsModel> newClassStudents = box.values
//       //     .where((element) =>
//       //         element.classTime ==
//       //         ClassesCubit.get(context).getClassName(currentClass))
//       //     .toList();
//       // currentClass.students = newClassStudents;
//       // currentClass.save();
//       //  final studentHistoryBox = await Hive.openBox<StudentHistory>(MyStrings.studentHistoryBox);
//       // StudentHistory studentRecord= StudentHistory(
//       //      comment: '-',
//       //      classDate: classDate.toString(),
//       //      costPurchased: 0.0,
//       //      degree: '',
//       //      hwDegree: '',
//       //      hwStatus: false,
//       //      quizDegree: '',
//       //      quizStatus: false);
//       // final key=await studentHistoryBox.add(studentRecord);
//       //  final studentHistoryObject = studentHistoryBox.get(key);
//       //  student.studentHistory![classDate.toString()] = studentHistoryObject!;
//       //  print(student.studentHistory![classDate.toString()]?.classDate);
//
//       // student.studentHistory!.addAll({'$classDate': studentRecord});
//       // await student.save();
//       StudentsCubit.get(context).getAllStudents();
//       ClassesCubit.get(context).getAllClasses();
//       emit(AddAttendantStudentSuccess());
//     } catch (error) {
//       print(error.toString());
//       emit(AddAttendantStudentError(error.toString()));
//     }
//   }
//
//   List<StudentsModel>? classStudents = [];
//   void getClassStudents(ClassModel currentClass, BuildContext context) {
//     classStudents = StudentsCubit.get(context)
//         .students
//         ?.where((student) =>
//             student.classTime ==
//             ClassesCubit.get(context).getClassName(currentClass))
//         .toList();
//     print('$classStudents /////////////////////////');
//     emit(GetClassStudents());
//   }
//
//   void editComment(StudentsModel student, ClassModel currentClass,
//       BuildContext context) async {
//     try {
//       emit(EditFieldLoad());
//       final comment = await showTextDialog(
//         context,
//         title: 'Change comment',
//         value: student.studentHistory!['${currentClass.date}']!.comment,
//       );
//
//       //update history box
//       final historyBox = sl<Box<StudentHistory>>();
//       print(historyBox.values.toList());
//       print(student.studentHistory![ClassesCubit.get(context).getClassName(currentClass)]);
//       final List<StudentHistory> record = historyBox.values
//           .where((element) =>
//               element ==
//               student.studentHistory![ClassesCubit.get(context).getClassName(currentClass)])
//           .toList();
//       record[0].comment = comment;
//
//       await record[0].save();
//
//       //update student box
//       final studentsBox = sl<Box<StudentsModel>>();
//       List<StudentsModel> requiredStudent =
//           studentsBox.values.where((element) => element == student).toList();
//       requiredStudent[0].studentHistory![currentClass.date.toString()] =
//           record[0];
//       await requiredStudent[0].save();
//
// getClassStudents(currentClass, context);
//       StudentsCubit.get(context).getAllStudents();
//       ClassesCubit.get(context).getAllClasses();
//       emit(EditFieldSuccess());
//     } catch (error) {
//       print(error.toString());
//       emit(EditFieldError());
//     }
//   }
//   void editHwDegree(StudentsModel student, ClassModel currentClass,
//       BuildContext context) async {
//     try {
//       emit(EditFieldLoad());
//       final hwDegree = await showTextDialog(
//         context,
//         title: 'Change HW degree',
//         value: student.studentHistory!['${currentClass.date}']!.hwDegree,
//       );
//       //update history box
//       final historyBox = sl<Box<StudentHistory>>();
//       final List<StudentHistory> record = historyBox.values
//           .where((element) =>
//       element ==
//           student.studentHistory![
//           ClassesCubit.get(context).getClassName(currentClass)])
//           .toList();
//       record[0].hwDegree = hwDegree;
//
//       await record[0].save();
//
//       //update student box
//       final studentsBox = sl<Box<StudentsModel>>();
//       List<StudentsModel> requiredStudent =
//       studentsBox.values.where((element) => element == student).toList();
//       requiredStudent[0].studentHistory![currentClass.date.toString()] =
//       record[0];
//       await requiredStudent[0].save();
//
//       getClassStudents(currentClass, context);
//       StudentsCubit.get(context).getAllStudents();
//       ClassesCubit.get(context).getAllClasses();
//       emit(EditFieldSuccess());
//     } catch (error) {
//       emit(EditFieldError());
//     }
//   }
//   void editPayment(StudentsModel student, ClassModel currentClass,
//       BuildContext context) async {
//     try {
//       emit(EditFieldLoad());
//       final payment = await showTextDialog(
//         context,
//         title: 'Change Payment',
//         value: student.studentHistory!['${currentClass.date}']!.costPurchased
//             .toString(),
//       );
//       final historyBox = sl<Box<StudentHistory>>();
//       final List<StudentHistory> record = historyBox.values
//           .where((element) =>
//       element ==
//           student.studentHistory![
//           ClassesCubit.get(context).getClassName(currentClass)])
//           .toList();
//       record[0].costPurchased = payment;
//
//       await record[0].save();
//
//       //update student box
//       final studentsBox = sl<Box<StudentsModel>>();
//       List<StudentsModel> requiredStudent =
//       studentsBox.values.where((element) => element == student).toList();
//       requiredStudent[0].studentHistory![currentClass.date.toString()] =
//       record[0];
//       await requiredStudent[0].save();
//
//       getClassStudents(currentClass, context);
//       StudentsCubit.get(context).getAllStudents();
//       ClassesCubit.get(context).getAllClasses();
//       emit(EditFieldSuccess());
//     } catch (error) {
//       emit(EditFieldError());
//     }
//   }
//
//
//
//   void updateClassDetails(
//       ClassModel currentClass,
//       DateTime date,
//       String centerName,
//       double price,
//       String time,
//       BuildContext context) async {
//     try {
//       currentClass.time = time;
//       currentClass.centerName = centerName;
//       currentClass.date = date;
//       currentClass.lessonPrice = price;
//       await currentClass.save();
//       ClassesCubit.get(context).getAllClasses();
//       currentClass.students.forEach((student) async {
//         student.classTime =
//             ClassesCubit.get(context).getClassName(currentClass);
//         await student.save();
//       });
//       emit(UpdateDetailsSuccess());
//     } catch (error) {
//       emit(UpdateDetailsError());
//     }
//   }
}
