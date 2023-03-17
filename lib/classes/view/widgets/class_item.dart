import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/classes/view/widgets/get_day_function.dart';
import 'package:attenda/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/class_model.dart';
import 'class_card_info.dart';

class ClassItem extends StatelessWidget {
  const ClassItem({Key? key, required this.currentClass}) : super(key: key);
  final ClassModel currentClass;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.pushNamed(context,Routes.classDetailsRoute,arguments: currentClass);
      },
      child: Card(
        color: const Color(0xff89cff0),
        // Color(0xff89cff0).withOpacity(.5),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.w)),
          ),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClassCardInfo(
                          title: '',
                          value: getClassName(currentClass),
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        ClassCardInfo(
                            title: 'Date: ',
                            value: DateFormat.yMMMd().format(currentClass.date)),
                        SizedBox(
                          height: 5.h,
                        ),
                        ClassCardInfo(
                            title: 'Region: ', value: currentClass.region),
                        SizedBox(
                          height: 5.h,
                        ),
                        ClassCardInfo(
                            title: 'Center: ', value: currentClass.centerName),
                        SizedBox(
                          height: 5.h,
                        ),
                        ClassCardInfo(
                            title: 'Price: ',
                            value: currentClass.classPrice.toString()),
                      ],
                    ),
                  ),
                 currentClass.date.isAfter(DateTime.now())?
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await ClassesCubit.get(context).deleteClass(currentClass.date, getClassName(currentClass),context);
                    },
                  ):
                  Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
