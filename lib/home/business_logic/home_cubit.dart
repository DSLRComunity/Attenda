import 'package:attenda/register/models/register_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(BuildContext context) => BlocProvider.of<HomeCubit>(context);

  Future<void> logout() async {
    emit(LogoutLoading());
    await FirebaseAuth.instance.signOut().then((value) {
      emit(LogoutSuccess());
    });
  }

  UserModel? userData;

  Future<void> getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userData = UserModel.fromJson(value.data()!);
    }).catchError((error) {});
  }
}
