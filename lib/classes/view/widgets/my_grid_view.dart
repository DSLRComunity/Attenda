import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../business_logic/classes_cubit/classes_cubit.dart';
import 'class_item.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ClassesCubit,ClassesState>(
      builder: (context, state) {
        if(ClassesCubit.get(context).classes==[]){
          return const Center(child: CircularProgressIndicator(),);
        }else{
          return
            GridView.count(
              crossAxisCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 5.h,
              crossAxisSpacing: 5.w,
              scrollDirection: Axis.vertical,
              childAspectRatio: 1.w/2.4.h,
              children:ClassesCubit.get(context).classes!.map((c) => ClassItem(currentClass: c)).toList(),
            );
        }
      },

    );
  }
}