import 'package:flutter/material.dart';

class MyColors {
  static const Color primary=Color(0xff0cbd78);
  static const Color white=Color(0xffFFFFFF);
  static const black=Color(0xff011b20);
  static const Color grey =  Color(0xff9B9B9B);

  static const MaterialColor primarySwatch= MaterialColor(0xFF009688, <int,Color>{
    50:MyColors.primary ,
    100:MyColors.primary,
    200:MyColors.primary,
    300:MyColors.primary,
    400:MyColors.primary,
    500:MyColors.primary,
    600:MyColors.primary,
    700:MyColors.primary,
    800:MyColors.primary,
    900:MyColors.primary,

  });
}