import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: MyColors.primarySwatch,
  appBarTheme: AppBarTheme(
    backgroundColor: MyColors.primary,
    iconTheme: const IconThemeData(color: MyColors.white),
    elevation: 0.0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(
      color: MyColors.white,
      fontSize: 22.sp,
    ),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: MyColors.black,
    elevation: 10,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
          TextStyle(color: MyColors.primary, fontSize: 12.sp)),
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
        fontSize: 18.sp, color: MyColors.black, fontWeight: FontWeight.w300),
    bodyMedium: TextStyle(
        fontSize: 24.sp, color: MyColors.black, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(
        fontSize: 34.sp, color: MyColors.black, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(
      fontSize: 22.sp,
      color: MyColors.black,
      fontFamily: 'Poppins',
    ),
    displaySmall: TextStyle(
      color: MyColors.grey,
      fontSize: 14.sp,
    ),
  ),
);
