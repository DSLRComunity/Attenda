import 'package:attenda/core/network/connection.dart';
import 'package:attenda/core/network/dio_helper.dart';
import 'package:attenda/core/network/end_points.dart';
import 'package:attenda/core/services.dart';
import 'package:attenda/core/strings.dart';
import 'package:attenda/register/models/register_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(BuildContext context) => BlocProvider.of<HomeCubit>(context);

  Future<void> logout(BuildContext context) async {
    if (await sl<ConnectionStatus>().isConnected(context)) {
      try{
        emit(LogoutLoading());
        Response response = await DioHelper.putData(
            path: EndPoints.teacherLogout,
            parameters: null,
            data: null,
            );
        if (response.statusCode == 200) {
          emit(LogoutSuccess());
        }
      }on DioError catch(error){
        emit(LogoutError(error.response!.statusMessage.toString()));
      }
    }
  }

  UserModel? userData;

  Future<void> getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userData = UserModel.fromJson(value.data()!);
    }).catchError((error) {});
  }
}
