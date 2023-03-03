part of 'class_details_cubit.dart';

abstract class ClassDetailsState {}

class ClassDetailsInitial extends ClassDetailsState {}
////////////////////////////

class GetClassStudentsLoad extends ClassDetailsState {}
class GetClassStudentsError extends ClassDetailsState {
  String error;
  GetClassStudentsError(this.error);
}
class GetClassStudentsSuccess extends ClassDetailsState {}

///////////////////////////

class AddAttendantStudentLoad extends ClassDetailsState {}
class AddAttendantStudentError extends ClassDetailsState {
  String error;
  AddAttendantStudentError(this.error);
}
class AddAttendantStudentSuccess extends ClassDetailsState {}

//////////////////////////

class UpdateDetailsSuccess extends ClassDetailsState {}
class UpdateDetailsLoad extends ClassDetailsState {}
class UpdateDetailsError extends ClassDetailsState {
  String error;

  UpdateDetailsError(this.error);
}

//////////////////////////

class UpdateHistoryLoad extends ClassDetailsState {}

class UpdateHistorySuccess extends ClassDetailsState {}

class UpdateHistoryError extends ClassDetailsState {}

////////////////////////

class GetClassHistorySuccess extends ClassDetailsState {}

class GetClassHistoryLoad extends ClassDetailsState {}

class GetClassHistoryError extends ClassDetailsState {}
