import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../register/models/register_model.dart';
part 'new_teacher_state.dart';

class NewTeacherCubit extends Cubit<NewTeacherState> {
  NewTeacherCubit() : super(NewTeacherInitial());

  static NewTeacherCubit get(BuildContext context)=>BlocProvider.of(context);

  Future<void> registerTeacher({
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
    emit(RegisterTeacherLoad());
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUser(
        lastName: lastName,
        email: email,
        uId: createTeacherId(phone, governorateCode),
        phone: phone,
        firstName: firstName,
        technicalSupportNum: technicalSupportNum,
        expectedStudentsNum: expectedStudentsNum,
        governorate: governorate,
        governorateCode: governorateCode,
        subject: subject,
        firebaseUserId: credential.user!.uid,
      );
      emit(RegisterTeacherSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterTeacherError('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterTeacherError('The account already exists for that email.'));
      }
    } catch (e) {
      emit(RegisterTeacherError(e.toString()));
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
      name: firstName,
      email: email,
      phone: phone,
      technicalSupportNum: technicalSupportNum,
      governorate: governorate,
      expectedStudentsNum: expectedStudentsNum,
      subject: subject,
      address: '', password: '', confirmPassword: '',

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

  String createTeacherId(String phoneNumber, String code) {
    String id;
    String last7Num = phoneNumber.substring(3, 11);
    id = 'TH-$code-$last7Num';
    return id;
  }

}
