import 'package:attenda/center/center_login/models/login_error_login.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loginUser(BuildContext context,
      {required String email, required String password}) async {
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try {
        emit(LoginLoadingState());
        Response response = await DioHelper.postData(
            path: EndPoints.teacherLogin,
            data: {'email': email, 'password': password});
        if (response.statusCode == 200) {
          emit(LoginSuccess(response.data['token']));
        }
      } on DioError catch (error) {
        if (error.response?.statusCode == 401) {
          emit(LoginError(error.response?.data['data']['errors']));
        } else if (error.response?.statusCode == 422) {
          LoginErrorModel errors =
              LoginErrorModel.fromJson(error.response?.data);
          if (errors.data.email != null) {
            emit(LoginError(errors.data.email!));
          }else
          if (errors.data.password != null) {
            emit(LoginError(errors.data.password!));
          }
        } else {
          emit(LoginError(error.response.toString()));
        }
      }
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
}

// Future<void> completeRegister(
//     String expectedStudents, String technicalNumber, String password) async {
//   emit(CompleteRegisterLoad());
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .update({
//     'expectedStudentsNum': expectedStudents,
//     'technicalSupportNum': technicalNumber,
//     'isComplete': true,
//   }).then((value) async {
//     emit(CompleteRegisterSuccess());
//   }).catchError((error) {
//     emit(CompleteRegisterError(error.toString()));
//   });
//   await FirebaseAuth.instance.currentUser?.updatePassword(password);
// }
//
// bool isComplete=false;
// Future<void> checkComplete() async {
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get()
//       .then((value) {
//     var user=UserModel.fromJson(value.data()!);
//     isComplete=user.isComplete;
//     emit(CheckCompleteSuccess());
//   }).catchError((error) {
//     emit(CheckCompleteError(error.toString()));
//   });
// }
