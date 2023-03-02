part of 'add_student_cubit.dart';

abstract class AddStudentState {}

class AddStudentInitial extends AddStudentState {}

class AddStudentLoad extends AddStudentState {}

class AddStudentError extends AddStudentState {
  String error;
  AddStudentError(this.error);
}

class AddStudentSuccess extends AddStudentState {}
