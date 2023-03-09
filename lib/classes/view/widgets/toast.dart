import 'package:attenda/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

void showSuccessToast({required BuildContext context,required String message}){
ToastContext().init(context);
Toast.show(message, duration: Toast.lengthShort, gravity:  Toast.bottom,backgroundColor:MyColors.primary);
}

void showErrorToast({required BuildContext context,required String message,}){
  ToastContext().init(context);
  Toast.show(message, duration: 5, gravity:  Toast.bottom,backgroundColor:const Color(0xffff0000),);
}