import 'package:attenda/center/center_register/models/center_error_model.dart';
import 'package:attenda/center/center_register/models/center_model.dart';
import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'center_register_state.dart';

class CenterRegisterCubit extends Cubit<CenterRegisterState> {
  CenterRegisterCubit() : super(CenterRegisterInitial());

  static CenterRegisterCubit get(BuildContext context) =>
      BlocProvider.of<CenterRegisterCubit>(context);

  CenterRegisterModel? centerModel;

  Future<void> centerRegister(BuildContext context) async {
    try {
      if (await sl<ConnectionStatus>().isConnected(context)) {
        emit(RegisterLoad());
        Response response = await DioHelper.postData(
            path: EndPoints.centerRegister, data: centerModel!.toJson());
        if (response.statusCode == 201) {
          emit(RegisterSuccess());
        }
      }
    } on DioError catch (error) {
      if (error.response?.statusCode == 422) {
        List<String> registerErrors = [];
        CenterRegisterErrorModel errors =
            CenterRegisterErrorModel.fromJson(error.response?.data);
        if (errors.data.name != null) {
          registerErrors.add(errors.data.name!);
        }else
        if (errors.data.email != null) {
          registerErrors.add(errors.data.email!);
        }else
        if (errors.data.phone != null) {
          registerErrors.add(errors.data.phone!);
        }else
        if (errors.data.password != null) {
          registerErrors.add(errors.data.password!);
        }else
        if (errors.data.city != null) {
          registerErrors.add(errors.data.city!);
        }else
        if (errors.data.address != null) {
          registerErrors.add(errors.data.address!);
        }
        emit(RegisterError(registerErrors));
      } else {
        emit(RegisterError(['Something went error, please try again']));
      }
    }
  }

// bool isEmailVerified=false;
// Future<void>sendEmailVerification()async{
//   emit(SendVerificationLoad());
//   await FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value){
//     emit(SendVerificationSuccess());
//   });
// }
//
// Future<void>checkEmailVerified()async{
//   await FirebaseAuth.instance.currentUser!.reload();
//   isEmailVerified=FirebaseAuth.instance.currentUser!.emailVerified;
//   if(isEmailVerified){
//     emit(VerifiedSuccess());
//   }
// }
//
// Future<void>updateEmail(String attendaEmail)async{
//   await FirebaseAuth.instance.currentUser?.updateEmail(attendaEmail);
// }
// Future<void>setPassword(String password)async{
//   await FirebaseAuth.instance.currentUser?.updatePassword(password);
// }
//
// Future<void>createCenterCollection()async {
//   emit(CreateCenterLoad());
//   FirebaseFirestore.instance.collection('centers').doc(FirebaseAuth.instance.currentUser!.uid).set(centerModel!.toJson()).then((value){
//     emit(CreateCenterSuccess());
//   }).catchError((error){
//     print(error.toString());
//     emit(CreateCenterError());});
//
// }
}
