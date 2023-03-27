import 'package:attenda/center/center_register/models/center_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'center_register_state.dart';

class CenterRegisterCubit extends Cubit<CenterRegisterState> {
  CenterRegisterCubit() : super(CenterRegisterInitial());

  static CenterRegisterCubit get(BuildContext context)=>BlocProvider.of<CenterRegisterCubit>(context);

  CenterModel? centerModel;
  Future<void>centerRegister()async {
    emit(RegisterFirstStepLoad());
   await FirebaseAuth.instance.createUserWithEmailAndPassword(email: centerModel!.email, password: '123456').then((value){
      emit(RegisterFirstStepSuccess());
    }).catchError((error){
     emit(RegisterFirstStepError());
    });
  }

  bool isEmailVerified=false;
  Future<void>sendEmailVerification()async{
    emit(SendVerificationLoad());
    await FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value){
      emit(SendVerificationSuccess());
    });
  }

  Future<void>checkEmailVerified()async{
    await FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    if(isEmailVerified){
      emit(VerifiedSuccess());
    }
  }

  Future<void>updateEmail(String attendaEmail)async{
    await FirebaseAuth.instance.currentUser?.updateEmail(attendaEmail);
  }
  Future<void>setPassword(String password)async{
    await FirebaseAuth.instance.currentUser?.updatePassword(password);
  }

  Future<void>createCenterCollection()async {
    emit(CreateCenterLoad());
    FirebaseFirestore.instance.collection('centers').doc(FirebaseAuth.instance.currentUser!.uid).set(centerModel!.toJson()).then((value){
      emit(CreateCenterSuccess());
    }).catchError((error){
      print(error.toString());
      emit(CreateCenterError());});

  }
}
