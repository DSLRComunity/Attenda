import 'package:flutter/material.dart';

import '../../business_logic/add_student_cubit/add_student_cubit.dart';

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
    return  DropdownButton<dynamic>(
        value:selectedValue?? widget.menuItems[0].value,
        onChanged: (Object? newValue){
          setState((){
            selectedValue=newValue;
          //  AddStudentCubit.get(context).className=selectedValue;
          });
        },
        items: widget.menuItems,
    );
  }
}
