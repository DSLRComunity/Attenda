import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../business_logic/classes_cubit/classes_cubit.dart';
import 'class_item.dart';

class MyGridView extends StatefulWidget {
  const MyGridView({Key? key,}) : super(key: key);

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ClassesCubit,ClassesState>(
      builder: (context, state) {
        if(ClassesCubit.get(context).classes==[]){
          return const Center(child: CircularProgressIndicator(),);
        }else {
          return GridView.count(
            crossAxisCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 5.h,
            crossAxisSpacing: 5.w,
            scrollDirection: Axis.vertical,
            childAspectRatio: 1.w / 2.h,
            children: ClassesCubit.get(context)
                .classes!
                .map((c) => ClassItem(currentClass: c))
                .toList(),
          );
        }
      },

    );
  }
}
