part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class GetManageHistorySuccess extends HistoryState {}

class GetManageHistoryLoad extends HistoryState {}

class GetManageHistoryError extends HistoryState {
  String error;
  GetManageHistoryError(this.error);
}

class GetAttendanceHistorySuccess extends HistoryState {}

class GetAttendanceHistoryLoad extends HistoryState {}

class GetAttendanceHistoryError extends HistoryState {
  String error;
  GetAttendanceHistoryError(this.error);
}
