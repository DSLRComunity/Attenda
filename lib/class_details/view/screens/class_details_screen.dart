import 'package:attenda/class_details/view/widgets/class_details.dart';
import 'package:attenda/class_details/view/widgets/class_students.dart';
import 'package:attenda/class_details/view/widgets/history_details.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../classes/models/class_model.dart';
import '../../../classes/view/widgets/get_day_function.dart';
import '../../business_logic/class_details_cubit.dart';

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({Key? key, required this.currentClass})
      : super(key: key);

  final ClassModel currentClass;

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  void _getClassStudents() async {
    ClassDetailsCubit.get(context).totalMoney=0;
    ClassDetailsCubit.get(context)..classAttendants=0;
    await ClassDetailsCubit.get(context).getClassStudents(widget.currentClass);
    await ClassDetailsCubit.get(context).getClassAttendantStudents(widget.currentClass);
    await ClassDetailsCubit.get(context).getClassHistory(widget.currentClass);
    await  ClassDetailsCubit.get(context).getTotalMoney(widget.currentClass);
    await ClassDetailsCubit.get(context).getClassAttendantsNum(widget.currentClass);

  }

  @override
  void initState() {
    _getClassStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        title: Text(
          getClassName(
            widget.currentClass,
          ),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: MyColors.primary),
        ),
      ),
      body:  Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*.8,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .35,
                      child: ClassDetails(
                        currentClass: widget.currentClass,
                      ),
                    ),
                    Divider(
                      thickness: 2.h,
                      color: Colors.black,
                    ),
                    Expanded(child: HistoryDetails(currentClass: widget.currentClass)),
                  ],
                ),
              ),
              const VerticalDivider(),
             Expanded(child: ClassStudents(currentClass: widget.currentClass)),
            ],
          ),
    );
  }

}
