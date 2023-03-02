part of 'add_classes_cubit.dart';

abstract class AddClassState {}

class ClassesInitial extends AddClassState {}

class AddClassLoad extends AddClassState {}

class AddClassError extends AddClassState {
   String error;
   AddClassError(this.error);
}

class AddClassSuccess extends AddClassState {}
