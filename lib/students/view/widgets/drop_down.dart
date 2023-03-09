import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';

class MyDropDown extends StatefulWidget {
   MyDropDown({Key? key,required this.menuItems}) : super(key: key);
  List<DropdownMenuItem<dynamic>> menuItems;

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  dynamic selectedValue;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Container(
        width: 80.w,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.r))
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: DropdownButton<dynamic>(
            value:selectedValue?? widget.menuItems[0].value,
          isExpanded: true,
          underline: Container(),
          menuMaxHeight: double.maxFinite,
            onChanged: (Object? newValue){
              setState((){
                selectedValue=newValue;
              //  AddStudentCubit.get(context).className=selectedValue;
              });
            },
            items: widget.menuItems,
        ),
      ),
    );
  }
}
