import 'package:attenda/classes/view/widgets/get_day_function.dart';
import 'package:attenda/history/models/history_model.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/class_model.dart';
import 'package:intl/intl.dart';

part 'add_classes_state.dart';

class AddClassCubit extends Cubit<AddClassState> {
  AddClassCubit() : super(ClassesInitial());

  static AddClassCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> addClass(ClassModel myClass, BuildContext context) async {
    DateTime initialDate = myClass.date;
    emit(AddClassLoad());
    try {
      int iteration = myClass.iteration;
      FirebaseFirestore instance = FirebaseFirestore.instance;
      await instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(getClassName(myClass))
          .set(myClass.toJson());
      for (int i = 1; i <= iteration; i++) {
        instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('classes')
            .doc(getClassName(myClass))
            .collection('dates')
            .doc(initialDate.toString())
            .set(myClass.toJson());
        await Future.delayed(const Duration(milliseconds: 500));
        initialDate = initialDate.add(const Duration(days: 7));
      }
      await StudentsCubit.get(context).addToManageHistory(HistoryModel(
        userName: HomeCubit.get(context).userData!.name!,
        message:
            'has added a new class ${getClassName(myClass)} in ${myClass.region} at center ${myClass.centerName} starts at date ${DateFormat('yyyy-MM-dd').format(myClass.date)} with price ${myClass.classPrice} and will be repeated ${myClass.iteration} times ',
        date: DateFormat.yMEd().add_jms().format(DateTime.now()),
      ));
      emit(AddClassSuccess());
    } catch (error) {
      emit(AddClassError(error.toString()));
    }
  }
}
