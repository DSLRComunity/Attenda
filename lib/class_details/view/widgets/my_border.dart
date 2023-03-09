import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';

InputDecoration myBorder(bool isUpdate){
  return  InputDecoration(
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.grey),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.grey),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 3.w),
    filled: true,
    fillColor: isUpdate? Colors.white:Colors.transparent,
  );
}