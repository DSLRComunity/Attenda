import 'dart:convert';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' show AnchorElement, document;
import '../../students/models/student_history_model.dart';

class MyFunctions {
 static String? makeTemplate(StudentHistory history,BuildContext context,String name) {

    String hwStatus = history.hwStatus ? 'سلم الواجب' : 'لم يسلم الواجب ';
    String date =DateFormat('MM-dd').format(DateTime.now());
    String gender=history.gender=='Male'? 'ابنكم':'ابنتكم';
    String subject=HomeCubit.get(context).userData!.subject!;
    String teacherName=HomeCubit.get(context).userData!.firstName!;
    String template = 'مرحبا بك في المنصة التعليمية ل مستر  ${teacherName} الي ولي امر الطالب ${name}  قد حضر $gender حصة $subject يوم $date و قد ${history.quizStatus} الاختبار بدرجة ${history.quizDegree} و بخصوص الواجب $hwStatus بدرجة ${history.hwDegree} و قام بدفع ${history.costPurchased} جنية , و خاصه بتعليق المدرس الخاص ف ${history.comment} ';
    return template;

  }
static String? validateMobile(String? value) {
   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
   RegExp regExp = RegExp(pattern);
   if (value!.isEmpty) {
     return 'Please enter mobile number';
   } else if (!regExp.hasMatch(value)) {
     return 'Please enter valid mobile number';
   }
   return null;
 }
 static   void takeScreenShot(String name,ScreenshotController controller)async{
   final image=await controller.capture();
   if (image != null) {
     if(kIsWeb){
       final anchor = AnchorElement(href: 'data:application/octet-stream;base64,${base64.encode(image)}')..download = "$name.png"..target='blank';
       document.body!.append(anchor);
       anchor.click();
       anchor.remove();

       // String? x= anchor.text;
       // // print(x);
       // // Share.shareXFiles([XFile(x!)]);
     }
   }
 }

}

