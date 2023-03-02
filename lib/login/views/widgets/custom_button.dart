import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';

class CustomLoginButton extends StatelessWidget {
  const CustomLoginButton({Key? key, required this.onPressed,required this.text})
      : super(key: key);
  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: MyColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          text,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white,fontSize: 20.sp),
        ),
      ),
    );
  }
}
