import 'package:attenda/center/center_login/models/login_error_login.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'center_login_state.dart';

class CenterLoginCubit extends Cubit<CenterLoginState> {
  CenterLoginCubit() : super(CenterLoginInitial());

  static CenterLoginCubit get(BuildContext context) =>
      BlocProvider.of<CenterLoginCubit>(context);

  Future<void> loginCenter(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      if (await sl<ConnectionStatus>().isConnected(context)) {
        emit(LoginLoadingState());
        Response response = await DioHelper.postData(
            path: EndPoints.centerLogin,
            data: {'email': email, 'password': password});
        if (response.statusCode == 200) {
          emit(LoginSuccess(response.data['token']));
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        emit(LoginError(e.response?.data['data']['errors']));
      } else if (e.response?.statusCode == 422) {
        LoginErrorModel errors = LoginErrorModel.fromJson(e.response?.data);
        if (errors.data.email != null) {
          emit(LoginError(errors.data.email!));
        }else
        if (errors.data.password != null) {
          emit(LoginError(errors.data.password!));
        }
      }else{
        emit(LoginError(e.response.toString()));
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

// Future<void> loginCenter({required String email, required String password}) async {
//   emit(LoginLoadingState());
//   try {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((loginCenter){
//       if (kDebugMode) {
//         print('${loginCenter.user!.uid}/////////////////////////////////////');
//       }
//       uId=loginCenter.user!.uid;
//       emit(LoginSuccess(loginCenter.user!.uid));
//
//     });
//   } on FirebaseAuthException catch (error) {
//     if (error.code == 'user-not-found') {
//       emit(LoginError(error.toString()));
//     } else if (error.code == 'wrong-password') {
//       emit(LoginError(error.toString()));
//     }
//   } catch (error) {
//     emit(LoginError(error.toString()));
//   }
// }
