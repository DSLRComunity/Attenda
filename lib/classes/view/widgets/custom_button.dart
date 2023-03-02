import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key,required this.text,required this.onPressed}) : super(key: key);

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: MyColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r),
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
    );
  }
}
