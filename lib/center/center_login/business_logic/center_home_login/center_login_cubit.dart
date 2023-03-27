import 'package:attenda/center/center_register/view/screens/set_password_screen.dart';
import 'package:attenda/center/center_register/view/screens/verification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../center_register/view/screens/censter_register_screen.dart';
import '../../view/screens/center_login_screen.dart';
part 'center_login_state.dart';

class CenterHomeLoginCubit extends Cubit<CenterHomeLoginState> {
  CenterHomeLoginCubit() : super(Initial());

 static CenterHomeLoginCubit get(BuildContext context)=>BlocProvider.of(context);

  Widget view= CenterLoginScreen();

  void changeToLogin(){
    view= CenterLoginScreen();
    emit(ChangeView());
  }
  void changeToRegister(){
    view= const CenterRegisterScreen();
    emit(ChangeView());
  }
  void changeToVerification(String email){
    view= VerificationScreen(email:email);
    emit(ChangeView());
  }

  void changeToSetPassword(String attendaEmail){
    view=SetPasswordScreen(attendaEmail: attendaEmail);
    emit(ChangeView());
  }
}
