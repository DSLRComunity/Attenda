part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetCenterDataLoad extends ProfileState {}

class GetCenterDataSuccess extends ProfileState {}

class GetCenterDataError extends ProfileState {
  String error;
  GetCenterDataError(this.error);
}