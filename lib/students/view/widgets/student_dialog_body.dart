import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:attenda/whatsapp/business_logic/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/colors.dart';


class StudentDialogBody extends StatefulWidget {
  const StudentDialogBody({Key? key,required this.id, required this.name, required this.className}) : super(key: key);

  final String id;
  final String name;
  final String className;

  @override
  State<StudentDialogBody> createState() => _StudentDialogBodyState();
}

class _StudentDialogBodyState extends State<StudentDialogBody> {
  final ScreenshotController _screenshotController=ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AlertDialog(
          backgroundColor: MyColors.white,
          elevation:0,
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
                        // const Text('Student Added Successfully',style: TextStyle(color: MyColors.primary),),
                        SizedBox(height: 40.h,),
                        Container(
                          alignment: Alignment.center,
                          height: 200.h,
                          width: 200.w,
                          child: QrImage(
                            data: widget.id,
                            version: QrVersions.auto,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        SelectableText(widget.name,style: const TextStyle(fontSize: 28),),
                        SizedBox(height: 5.h),
                        SelectableText(widget.className,style: const TextStyle(fontSize: 28),),
                        SizedBox(height: 5.h),
                        SelectableText(widget.id,style: const TextStyle(fontSize: 28),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  CustomButton(text: 'Take screenshot and share', onPressed: ()async{
                    MyFunctions.takeScreenShot(widget.name,_screenshotController);
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
