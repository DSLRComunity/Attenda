part of 'classes_cubit.dart';


abstract class ClassesState {}

class ClassesInitial extends ClassesState {}

class GetClassesLoad extends ClassesState {}

class GetClassesError extends ClassesState {
  String error;
  GetClassesError(this.error);
}

class GetClassesSuccess extends ClassesState {}

class DeleteClassSuccess extends ClassesState {}

class DeleteClassLoad extends ClassesState {}

class DeleteClassError extends ClassesState {
  String error;
  DeleteClassError(this.error);
}