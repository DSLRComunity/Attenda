import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/class_model.dart';
import '../../view/widgets/get_day_function.dart';
part 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  ClassesCubit() : super(ClassesInitial());

  static ClassesCubit get(BuildContext context) => BlocProvider.of(context);

  List<ClassModel>? classes = [];

  Future<void> getAllClasses() async {
    List<ClassModel>? tempClasses = [];
    emit(GetClassesLoad());

    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes')
        .get()
        .then((classesNames) {
      print('$classesNames/////////////////////////');
      classesNames.docs.forEach((currentClass) async {
        print('$currentClass');
        await currentClass.reference
            .collection('dates')
            .get()
            .then((classDates) {
          print('$classDates/////////////////');
          classDates.docs.forEach((element) {
            print('$element');
            tempClasses
                .add(ClassModel.fromJson(currentClass.data(), element.id));
            List<ClassModel>? sortedClasses = tempClasses
              ..sort((a, b) => b.date.compareTo(a.date));
            classes = sortedClasses.reversed.toList();
            emit(GetClassesSuccess());
            print(classes);
          });
        }).catchError((error) {
          emit(GetClassesError(error.toString()));
        });
      });
    }).catchError((error) {
      emit(GetClassesError(error.toString()));
    });
    //getClassesDates();
  }

  Future<void> deleteClass(String date, String className) async {
    emit(DeleteClassLoad());
    FirebaseFirestore instance = FirebaseFirestore.instance;
    CollectionReference users = instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('classes');
    await users
        .doc(className)
        .collection('dates')
        .doc(date)
        .delete()
        .then((value) {
      print('deleteSuccess////////////////////');
      emit(DeleteClassSuccess());
    }).catchError((error) {
      print('${DeleteClassError(error.toString())}////////////////////');
      emit(DeleteClassError(error.toString()));
    });
  }

  Set<String> classesNames() {
    return classes!
        .map((currentClass) =>
    '${getDayFrom(currentClass.date)}, ${currentClass.time}')
        .toSet();
    
  }


//
// List<DateTime>dates=[];
// void getClassesDates(){
//   dates=[];
//   classes!.forEach((currentClass) {
//     dates.add(currentClass.date);
//   });
// }
//
}
