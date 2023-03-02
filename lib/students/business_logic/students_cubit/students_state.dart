part of 'students_cubit.dart';

abstract class StudentsState {}

class StudentsInitial extends StudentsState {}

class GetStudentsLoad extends StudentsState {}

class GetStudentsError extends StudentsState {
  String error;
  GetStudentsError(this.error);
}

class GetStudentsSuccess extends StudentsState {}

class UpdateStudentSuccess extends StudentsState {}

class UpdateStudentLoad extends StudentsState {}

class UpdateStudentError extends StudentsState {
  String error;
  UpdateStudentError(this.error);
}

class GetStudentHistoryLoad extends StudentsState {}

class GetStudentHistorySuccess extends StudentsState {}

class GetStudentHistoryError extends StudentsState {
  String error;
  GetStudentHistoryError(this.error);
}

