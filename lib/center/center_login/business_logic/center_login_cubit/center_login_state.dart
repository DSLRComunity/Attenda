part of 'center_login_cubit.dart';

abstract class CenterLoginState {}

class CenterLoginInitial extends CenterLoginState {}

class LoginLoadingState extends CenterLoginState {}

class LoginSuccess extends CenterLoginState {
  String token;
  LoginSuccess(this.token);
}

class LoginError extends CenterLoginState {
  String error;
  LoginError(this.error);
}

class ChangePassVisibilityState extends CenterLoginState {}

class ChangeRememberMe extends CenterLoginState {}
