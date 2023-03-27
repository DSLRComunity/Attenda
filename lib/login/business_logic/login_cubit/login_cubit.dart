import 'package:attenda/core/strings.dart';
import 'package:attenda/register/models/register_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((loginUser) {
        if (kDebugMode) {
          print('${loginUser.user!.uid}/////////////////////////////////////');
        }
        uId = loginUser.user!.uid;
        emit(LoginSuccess(loginUser.user!.uid));
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        emit(LoginError(error.toString()));
      } else if (error.code == 'wrong-password') {
        emit(LoginError(error.toString()));
      }
    } catch (error) {
      emit(LoginError(error.toString()));
    }
  }

  bool isVisible = true;
  var visibleIcon = Icons.visibility;

  dynamic changePassVisibility() {
    if (isVisible == true) {
      visibleIcon = Icons.visibility_off;
      isVisible = false;
      emit(ChangePassVisibilityState());
    } else {
      visibleIcon = Icons.visibility;
      isVisible = true;
      emit(ChangePassVisibilityState());
    }
  }

  bool rememberMe = false;

  void changeRememberMe(bool? value) {
    rememberMe = value!;
    emit(ChangeRememberMe());
  }

  Future<void> completeRegister(
      String expectedStudents, String technicalNumber, String password) async {
    emit(CompleteRegisterLoad());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'expectedStudentsNum': expectedStudents,
      'technicalSupportNum': technicalNumber,
      'isComplete': true,
    }).then((value) async {
      emit(CompleteRegisterSuccess());
    }).catchError((error) {
      emit(CompleteRegisterError(error.toString()));
    });
    await FirebaseAuth.instance.currentUser?.updatePassword(password);
  }

  bool isComplete=false;
  Future<void> checkComplete() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var user=UserModel.fromJson(value.data()!);
      isComplete=user.isComplete;
      emit(CheckCompleteSuccess());
    }).catchError((error) {
      emit(CheckCompleteError(error.toString()));
    });
  }
}
