import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../students/models/student_history_model.dart';

String? makeTemplate(StudentHistory history,BuildContext context,String name) {

  String hwStatus = history.hwStatus ? 'سلم الواجب' : 'لم يسلم الواجب ';
  String date =DateFormat('MM-dd').format(DateTime.now());
  String gender=history.gender=='Male'? 'ابنكم':'ابنتكم';
  String subject=HomeCubit.get(context).userData!.subject!;
  String teacherName=HomeCubit.get(context).userData!.firstName!;
  String template = 'مرحبا بك في المنصة التعليمية ل مستر  ${teacherName} الي ولي امر الطالب ${name}  قد حضر $gender حصة $subject يوم $date و قد ${history.quizStatus} الاختبار بدرجة ${history.quizDegree} و بخصوص الواجب $hwStatus بدرجة ${history.hwDegree} و قام بدفع ${history.costPurchased} جنية , و خاصه بتعليق المدرس الخاص ف ${history.comment} ';
  return template;

}