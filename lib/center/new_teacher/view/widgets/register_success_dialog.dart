import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/whatsapp/business_logic/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';


class TeacherDialogBody extends StatefulWidget {
  const TeacherDialogBody(
      {Key? key, required this.name, required this.email, required this.id, required this.password}) : super(key: key);
  final String email;
  final String name;
  final String id;
  final String password;

  @override
  State<TeacherDialogBody> createState() => _TeacherDialogBodyState();
}

class _TeacherDialogBodyState extends State<TeacherDialogBody> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AlertDialog(
          backgroundColor: MyColors.white,
          elevation: 0,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Center(
              child: Column(
                children: [
                  Screenshot(
                    controller: _screenshotController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Register Teacher Successfully',style: TextStyle(color: MyColors.primary),),
                        SizedBox(height: 40.h,),
                        SizedBox(height: 5.h),
                        SelectableText(
                          'Name:  ${widget.name}', style: const TextStyle(fontSize: 28),),
                        SizedBox(height: 5.h),
                        SelectableText('Email:  ${widget.email}',
                          style: const TextStyle(fontSize: 28),),
                        SizedBox(height: 5.h),
                        SelectableText(
                          'Id:  ${widget.id}', style: const TextStyle(fontSize: 28),),
                        SizedBox(height: 5.h),
                        SelectableText(
                          'Password:  ${widget.password}', style: const TextStyle(fontSize: 28),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  CustomButton(
                      text: 'Take screenshot and share', onPressed: () async {
                    MyFunctions.takeScreenShot(
                        widget.name, _screenshotController);
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
