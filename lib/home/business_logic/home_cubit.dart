import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
static HomeCubit get(BuildContext context)=>BlocProvider.of(context);

  Future<void>logout()async{
    emit(LogoutLoading());
    await FirebaseAuth.instance.signOut().then((value) {
      emit(LogoutSuccess());
    });
  }

}
