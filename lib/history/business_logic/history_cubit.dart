import 'package:attenda/history/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

 static HistoryCubit get(BuildContext context)=>BlocProvider.of<HistoryCubit>(context);

  List<HistoryModel>manageHistory=[];
  List<HistoryModel>attendanceHistory=[];
  Future<void>getManageHistory()async{
    emit(GetManageHistoryLoad());
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('manageHistory').get().then((value){
      value.docs.forEach((history) {
        manageHistory.add(HistoryModel.fromJson(history.data()));
      });
      print(manageHistory);
      emit(GetManageHistorySuccess());
    }).catchError((error){
      emit(GetManageHistoryError(error.toString()));
    });
  }
  Future<void>getAttendanceHistory()async{
    emit(GetAttendanceHistoryLoad());
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('attendanceHistory').get().then((value){
      value.docs.forEach((history) {
        attendanceHistory.add(HistoryModel.fromJson(history.data()));
      });
      emit(GetAttendanceHistorySuccess());
    }).catchError((error){
      emit(GetAttendanceHistoryError(error.toString()));
    });
  }

}
