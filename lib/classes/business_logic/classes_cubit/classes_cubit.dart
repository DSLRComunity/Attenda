import 'package:attenda/history/models/history_model.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/class_model.dart';
import '../../view/widgets/get_day_function.dart';
part 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  ClassesCubit() : super(ClassesInitial());

  static ClassesCubit get(BuildContext context) => BlocProvider.of(context);

  List<ClassModel>? classes = [];

  Future<void> getAllClasses() async {
    classes=[];
    List<ClassModel>? tempClasses = [];
    emit(GetClassesLoad());
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('classes');
    collectionReference.get().then((classesNames) {
      classesNames.docs.forEach((className) {
        collectionReference
            .doc(className.id)
            .collection('dates')
            .get()
            .then((classesDates) {
          classesDates.docs.forEach((classDate) {
            tempClasses
                .add(ClassModel.fromJson(classDate.data(), classDate.id));
            List<ClassModel>? sortedClasses = tempClasses
              ..sort((a, b) => b.date.compareTo(a.date));
            classes = sortedClasses.reversed.toList();
          });
          emit(GetClassesSuccess());
        }).catchError((error){
          emit(GetClassesError(error.toString()));
        });
      });
    }).then((value){
      emit(GetClassesSuccess());
    }).catchError((error){
      emit(GetClassesError(error.toString()));
    });
  }

  Future<void> deleteClass(DateTime date, String className, BuildContext context) async {
    emit(DeleteClassLoad());
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('classes')
            .doc(className)
            .collection('dates');
    CollectionReference<Map<String, dynamic>> collectionReference2 =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('classes')
            .doc(className)
            .collection('classStudents');
    DocumentReference<Map<String, dynamic>> documentReference =
        collectionReference.doc(date.toString());

    await collectionReference.doc(date.toString()).delete().then((value) {
      classes!.removeWhere((element) => element.date == date && getClassName(element) == className);
      emit(DeleteClassSuccess());
    }).catchError((error) {
      emit(DeleteClassError(error.toString()));
    });
    collectionReference.get().then((dates) async {
      if (dates.docs.isEmpty) {
        await documentReference.delete().then((value) async {
          collectionReference2.get().then((classStudents) {
            classStudents.docs.forEach((student) {
              collectionReference2.doc(student.id).delete();
            });
          });
          emit(DeleteClassSuccess());
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('classes')
              .doc(className)
              .delete();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid).collection('students').where('className',isEqualTo:className).get().then((students) {
                students.docs.forEach((student)async {
                 await student.reference.update({'className':""});
                });
          });
        });
      }
    });
    await StudentsCubit.get(context).addToManageHistory(HistoryModel(
      userName: HomeCubit.get(context).userData!.name!,
      message:
          'has deleted class $className that is at date ${DateFormat('yyyy-MM-dd').format(date)} ',
      date: DateFormat.yMEd().add_jms().format(DateTime.now()),
    ));
  }

  Set<String> getClassesNames() {
    return classes!
        .map((currentClass) =>
            '${getDayFrom(currentClass.date)}, ${currentClass.time}')
        .toSet();
  }
}
