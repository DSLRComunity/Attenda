import 'package:attenda/classes/view/widgets/get_day_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/class_model.dart';

part 'add_classes_state.dart';

class AddClassCubit extends Cubit<AddClassState> {
  AddClassCubit() : super(ClassesInitial());

  static AddClassCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> addClass(ClassModel myClass) async {
    DateTime initialDate=myClass.date;
    emit(AddClassLoad());
    try {
      int iteration = myClass.iteration;
      FirebaseFirestore instance = FirebaseFirestore.instance;
      await instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('classes')
          .doc(getClassName(myClass))
          .set(myClass.toJson());
      for (int i = 1; i<=iteration; i++) {
         instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('classes').doc(getClassName(myClass)).collection('dates').doc(initialDate.toString()).set({});
        await Future.delayed(const Duration(milliseconds: 500));
         initialDate= initialDate.add(Duration(days: 7 * i));
      }
      emit(AddClassSuccess());
    } catch (error) {
      emit(AddClassError(error.toString()));
    }
  }
}
