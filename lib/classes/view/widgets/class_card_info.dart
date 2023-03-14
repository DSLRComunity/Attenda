import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassCardInfo extends StatelessWidget {
  const ClassCardInfo({Key? key, required this.title, required this.value,this.fontWeight,this.fontSize})
      : super(key: key);
  final String title, value;
 final FontWeight? fontWeight;
 final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              height: 1.1.h,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20.sp,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(height: 1.1.h,color: Colors.black, fontSize:fontSize?? 18.sp,fontWeight:fontWeight),
          ),
        ],
      ),
    );
  }
}
