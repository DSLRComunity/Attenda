part of 'center_register_cubit.dart';

abstract class CenterRegisterState {}

class CenterRegisterInitial extends CenterRegisterState {}

class RegisterLoad extends CenterRegisterState {}

class RegisterSuccess extends CenterRegisterState {}

class RegisterError extends CenterRegisterState {
  List<String>errors;
  RegisterError(this.errors);
}