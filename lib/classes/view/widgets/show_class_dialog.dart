import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/add_class_cubit/add_classes_cubit.dart';
import 'class_dialog_body.dart';

void showClassDialog(BuildContext context,) {
  showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => AddClassCubit(),
          child: const ClassDialogBody(),
        );
      });
}
