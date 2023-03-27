import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/register_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String technicalSupportNum,
    required String expectedStudentsNum,
    required String governorate,
    required String governorateCode,
    required String subject,
  }) async {
    emit(RegisterLoad());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUser(
        lastName: lastName,
        email: email,
        uId: _createTeacherId(phone, governorateCode),
        phone: phone,
        firstName: firstName,
        technicalSupportNum: technicalSupportNum,
        expectedStudentsNum: expectedStudentsNum,
        governorate: governorate,
        governorateCode: governorateCode,
        subject: subject,
        firebaseUserId: credential.user!.uid,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterError('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterError('The account already exists for that email.'));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String uId,
    required String phone,
    required String technicalSupportNum,
    required String expectedStudentsNum,
    required String governorate,
    required String governorateCode,
    required String subject,
    required String firebaseUserId,
  }) async {
    emit(CreateUserLoad());
    UserModel userData = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      uId: uId,
      technicalSupportNum: technicalSupportNum,
      governorate: governorate,
      expectedStudentsNum: expectedStudentsNum,
      governorateCode: governorateCode,
      subject: subject,
      isComplete: true,
    );
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUserId)
          .set(userData.toJson());
      emit(CreateUserSuccess());
    } catch (error) {
      emit(CreateUserError(error.toString()));
    }
  }

  String _createTeacherId(String phoneNumber, String code) {
    String id;
    String last7Num = phoneNumber.substring(3, 11);
    id = 'TH-$code-$last7Num';
    return id;
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

}
