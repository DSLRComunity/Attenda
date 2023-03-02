import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class MyIconButton extends StatelessWidget {
  const MyIconButton({Key? key,required this.icon,required this.title}) : super(key: key);

  final String icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            icon,
            height: 50.h,
            fit: BoxFit.cover,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
