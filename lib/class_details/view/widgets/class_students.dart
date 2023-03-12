import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/students/models/students_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/colors.dart';
import '../../business_logic/class_details_cubit.dart';

class ClassStudents extends StatelessWidget {
  const ClassStudents({Key? key, required this.currentClass}) : super(key: key);
  final ClassModel currentClass;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
      buildWhen: (previous, current) => (current is GetClassHistoryLoad ||
          current is GetClassHistorySuccess ||
          current is GetClassHistoryError),
      builder: (context, state) {
        if (state is GetClassHistoryLoad) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ClassDetailsCubit.get(context)
                        .classStudents
                        .map((student) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: Row(
                                children: [
                                  FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(student.name)),
                                  const Spacer(),
                                  AttendButton(
                                      currentClass: currentClass,
                                      student: student),
                                ],
                              ),
                            ))
                        .toList(), //getStudentsNames(context),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class AttendButton extends StatefulWidget {
  const AttendButton(
      {Key? key, required this.currentClass, required this.student})
      : super(key: key);
  final ClassModel currentClass;
  final StudentsModel student;

  @override
  State<AttendButton> createState() => _AttendButtonState();
}

class _AttendButtonState extends State<AttendButton> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: MyColors.primary,
      child: IconButton(
          onPressed: () async {
            // ClassDetailsCubit.get(context).classAttendants++;
            // ClassDetailsCubit.get(context).totalMoney+=widget.currentClass.classPrice;
            await ClassDetailsCubit.get(context).updateMoneyCollected(widget.currentClass);
            await ClassDetailsCubit.get(context).updateNumOfAttendants(widget.currentClass);
            await ClassDetailsCubit.get(context).addToAttendance(widget.student, widget.currentClass);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
