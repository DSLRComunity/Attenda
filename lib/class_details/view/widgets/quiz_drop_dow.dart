import 'package:flutter/material.dart';

import '../../business_logic/class_details_cubit.dart';

class QuizDropDown extends StatefulWidget {
  const QuizDropDown({Key? key,required this.menuItems}) : super(key: key);
 final List<DropdownMenuItem<dynamic>> menuItems;

  @override
  State<QuizDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<QuizDropDown> {
  dynamic selectedValue;
  @override
  Widget build(BuildContext context) {
    return  DropdownButton<dynamic>(
      value:selectedValue?? widget.menuItems[0].value,
      onChanged: (Object? newValue){
        setState((){
          selectedValue=newValue;
          // ClassDetailsCubit.get(context).quizStatus=selectedValue;
        });
      },
      items: widget.menuItems,
    );
  }
}