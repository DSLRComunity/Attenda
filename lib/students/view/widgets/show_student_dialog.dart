import 'package:attenda/students/view/widgets/student_dialog_body.dart';
import 'package:flutter/material.dart';

void showStudentDialog(BuildContext context,String id){
  showDialog(
      context: context,
      builder: (context) {
        return  StudentDialogBody(id: id,);
      });
}