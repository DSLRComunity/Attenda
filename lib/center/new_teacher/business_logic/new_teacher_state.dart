part of 'new_teacher_cubit.dart';

abstract class NewTeacherState {}

class NewTeacherInitial extends NewTeacherState {}

class RegisterTeacherLoad extends NewTeacherState {}

class RegisterTeacherSuccess extends NewTeacherState {}

class RegisterTeacherError extends NewTeacherState {
  String error;
  RegisterTeacherError(this.error);
}

class CreateUserLoad extends NewTeacherState {}

class CreateUserSuccess extends NewTeacherState {}

class CreateUserError extends NewTeacherState {
  String error;
  CreateUserError(this.error);
}