part of 'center_register_cubit.dart';

@immutable
abstract class CenterRegisterState {}

class CenterRegisterInitial extends CenterRegisterState {}

class RegisterFirstStepLoad extends CenterRegisterState {}

class RegisterFirstStepSuccess extends CenterRegisterState {}

class RegisterFirstStepError extends CenterRegisterState {}

class SendVerificationLoad extends CenterRegisterState {}

class SendVerificationSuccess extends CenterRegisterState {}

class SendVerificationError extends CenterRegisterState {}

class VerifiedSuccess extends CenterRegisterState {}

class CreateCenterSuccess extends CenterRegisterState {}

class CreateCenterLoad extends CenterRegisterState {}

class CreateCenterError extends CenterRegisterState {}