import 'package:attenda/center/center_register/models/center_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(BuildContext context)=>BlocProvider.of<ProfileCubit>(context);

  CenterModel? centerData;
  Future<void> getCenterData() async {
    emit(GetCenterDataLoad());
    FirebaseFirestore.instance
        .collection('centers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      centerData = CenterModel.fromJson(value.data()!);
      emit(GetCenterDataSuccess());
    }).catchError((error) {
      emit(GetCenterDataError(error.toString()));
    });
  }
}
