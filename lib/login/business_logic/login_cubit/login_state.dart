part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccess extends LoginState {
  final String uId;

  LoginSuccess(this.uId);
}

class LoginError extends LoginState {
  String error;

  LoginError(this.error);
}

class ChangePassVisibilityState extends LoginState {}

class ChangeRememberMe extends LoginState {}

class CompleteRegisterLoad extends LoginState {}

class CompleteRegisterSuccess extends LoginState {

}

class CompleteRegisterError extends LoginState {
  String error;
  CompleteRegisterError(this.error);
}
class CheckCompleteLoad extends LoginState {}

class CheckCompleteSuccess extends LoginState {}

class CheckCompleteError extends LoginState {
  String error;
  CheckCompleteError(this.error);
}
