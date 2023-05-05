import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:attenda/register/models/register_error_model.dart';
import 'package:attenda/register/models/register_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> register(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String technicalSupportNum,
    required String expectedStudentsNum,
    required String governorate,
    required String address,
    required String subject,
  }) async {
    if (await sl<ConnectionStatus>().isConnected(context)) {
 try{
   emit(RegisterLoad());
   Response response = await DioHelper.postData(
       path: EndPoints.teacherRegister,
       data: UserModel(
           name: name,
           email: email,
           phone: phone,
           governorate: governorate,
           address: address,
           expectedStudentsNum: expectedStudentsNum,
           technicalSupportNum: technicalSupportNum,
           subject: subject,
           password: password,
           confirmPassword: confirmPassword).toJson());
   if(response.statusCode==201){
     emit(RegisterSuccess());
   }
 }on DioError catch(error){
   if (error.response?.statusCode == 422) {
     List<String> registerErrors = [];
     TeacherRegisterErrorModel errors = TeacherRegisterErrorModel.fromJson(error.response?.data);
     if (errors.data.name != null) {
emit(RegisterError(errors.data.name!));
     }else
     if (errors.data.email != null) {
       emit(RegisterError(errors.data.email!));
     }else
     if (errors.data.phone != null) {
       registerErrors.add(errors.data.phone!);
     }else
     if (errors.data.workPhone != null) {
       registerErrors.add(errors.data.workPhone!);
     }else
     if (errors.data.password != null) {
       registerErrors.add(errors.data.password!);
     }else
     if (errors.data.city != null) {
       registerErrors.add(errors.data.city!);
     }else
     if (errors.data.address != null) {
       registerErrors.add(errors.data.address!);
     }else
     if (errors.data.maxStudent != null) {
       registerErrors.add(errors.data.maxStudent!);
     }else
     if (errors.data.passwordConfirm != null) {
       registerErrors.add(errors.data.passwordConfirm!);
     }
   } else {
     emit(RegisterError('Something went error, please try again'));
   }
 }
    }
  }





  // String _createTeacherId(String phoneNumber, String code) {
  //   String id;
  //   String last7Num = phoneNumber.substring(3, 11);
  //   id = 'TH-$code-$last7Num';
  //   return id;
  // }
  bool isVisible = true;
  var visibleIcon = Icons.visibility;

  dynamic changePassVisibility() {
    if (isVisible == true) {
      visibleIcon = Icons.visibility_off;
      isVisible = false;
      emit(ChangePassVisibilityState());
    } else {
      visibleIcon = Icons.visibility;
      isVisible = true;
      emit(ChangePassVisibilityState());
    }
  }
}
