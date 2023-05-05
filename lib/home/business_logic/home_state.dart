part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class LogoutLoading extends HomeState {}

class LogoutSuccess extends HomeState {}

class LogoutError extends HomeState {
  String error;
  LogoutError(this.error);
}
