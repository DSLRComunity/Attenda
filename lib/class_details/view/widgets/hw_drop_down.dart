import 'package:flutter/material.dart';

import '../../business_logic/class_details_cubit.dart';

class HwDropDown extends StatefulWidget {
 const HwDropDown({Key? key,required this.menuItems}) : super(key: key);
  final List<DropdownMenuItem<dynamic>> menuItems;

  @override
  State<HwDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<HwDropDown> {
  dynamic selectedValue;
  @override
  Widget build(BuildContext context) {
    return  DropdownButton<dynamic>(
      value:selectedValue?? widget.menuItems[0].value,
      onChanged: (Object? newValue){
        setState((){
          selectedValue=newValue;
          // ClassDetailsCubit.get(context).hwStatus=selectedValue;
        });
      },
      items: widget.menuItems,
    );
  }
}