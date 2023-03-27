import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/strings.dart';
part 'center_login_state.dart';

class CenterLoginCubit extends Cubit<CenterLoginState> {
  CenterLoginCubit() : super(CenterLoginInitial());

  static CenterLoginCubit get(BuildContext context)=>BlocProvider.of<CenterLoginCubit>(context);

  Future<void> loginCenter({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((loginCenter){
        if (kDebugMode) {
          print('${loginCenter.user!.uid}/////////////////////////////////////');
        }
        uId=loginCenter.user!.uid;
        emit(LoginSuccess(loginCenter.user!.uid));

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

  bool rememberMe=false;
  void changeRememberMe(bool? value){
    rememberMe=value!;
    emit(ChangeRememberMe());
  }
}
