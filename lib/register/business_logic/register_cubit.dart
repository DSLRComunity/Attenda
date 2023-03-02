import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/register_model.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(BuildContext context)=>BlocProvider.of(context);

  Future<void> register({required String firstName,required String lastName, required String email, required String password, required String phone,}) async {
    emit(RegisterLoad());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUser(lastName: lastName,email: email, uId: credential.user!.uid, phone: phone, firstName:firstName);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterError('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterError('The account already exists for that email.'));
        }
        } catch (e)
        {
          emit(RegisterError(e.toString()));
        }
      }

  Future<void>createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String uId,
    required String phone
  })async {
    emit(CreateUserLoad());
    UserModel userData=UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      uId: uId,
    );
    try{
      await FirebaseFirestore.instance.collection('users').doc(uId).set(userData.toJson());
      emit(CreateUserSuccess());
    }catch(error){
      print(error.toString());
      emit(CreateUserError(error.toString()));
    };

  }
}