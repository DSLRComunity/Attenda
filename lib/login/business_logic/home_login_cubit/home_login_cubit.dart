import 'package:attenda/login/views/screens/login_screen.dart';
import 'package:attenda/register/views/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_login_state.dart';

class HomeLoginCubit extends Cubit<HomeLoginState> {
  HomeLoginCubit() : super(HomeLoginInitial());

  static HomeLoginCubit get(BuildContext context)=>BlocProvider.of(context);

  Widget view=LoginScreen();

  void changeToLogin(){
    view=LoginScreen();
    emit(ChangeView());
  }
  void changeToRegister(){

    view=const RegisterScreen();
    emit(ChangeView());
  }
}
