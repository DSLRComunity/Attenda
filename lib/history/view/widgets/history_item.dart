import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({Key? key,required this.message,required this.date}) : super(key: key);
final String message;
final String date;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: RichText(text: TextSpan(
children:[
  TextSpan(
      text: '${HomeCubit.get(context).userData!.name}  ',
      style:TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 22.sp),
  ),
  TextSpan(
      text: message,
      style:TextStyle(fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.8),fontSize: 22.sp),
  ),
  TextSpan(text:date,style: Theme.of(context).textTheme.displaySmall),
],
      )),
    );
  }
}
