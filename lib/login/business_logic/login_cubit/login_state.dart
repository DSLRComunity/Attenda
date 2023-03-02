part of 'login_cubit.dart';

@immutable
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
