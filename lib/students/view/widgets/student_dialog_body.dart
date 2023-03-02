import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/colors.dart';

class StudentDialogBody extends StatelessWidget {
  const StudentDialogBody({Key? key,required this.id}) : super(key: key);

  final String id;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.white,
      elevation:0,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Student Added Successfully',style: TextStyle(color: MyColors.primary),),
              SizedBox(height: 50.h,),
              Container(
                alignment: Alignment.center,
                height: 100.h,
                width: 100.w,
                child: QrImage(
                  data: id,
                  version: QrVersions.auto,
                ),
              ),
              SizedBox(height: 5.h),
              SelectableText(id)
            ],
          ),
        ),
      ),
    );
  }

}
