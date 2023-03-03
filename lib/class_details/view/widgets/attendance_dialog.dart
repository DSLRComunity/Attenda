import 'package:attenda/core/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../classes/models/class_model.dart';
import '../../../classes/view/widgets/custom_button.dart';
import '../../../students/models/students_model.dart';
import '../../business_logic/class_details_cubit.dart';

class AttendanceDialog extends StatefulWidget {
  const AttendanceDialog(
      {Key? key, required this.attendanceStudents, required this.currentClass})
      : super(key: key);
  final List<StudentsModel> attendanceStudents;
  final ClassModel currentClass;

  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  TextEditingController searchController = TextEditingController();
  List<StudentsModel> searchList = [];
  bool searched = false;
  String searchWord = ' ';
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Search For a Student'),
          SizedBox(
            height: 50.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120.w,
                child: TextFormField(
                  onChanged: (value) {
                    searched = true;
                    setState(() {
                      searchList = widget.attendanceStudents
                          .where((student) => student.id.startsWith(value))
                          .toList();
                      itemCount = searchList.length;
                      searchWord = value;
                    });
                  },
                  controller: searchController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16),
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: const Color(0xffF8F8F8),
                      prefixIcon: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.search_outlined)),
                      hintText: "Search",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 16)),
                ),
              ),
              SizedBox(width: 5.w,),
              const Text('OR'),
              SizedBox(
                width: 20.w,
                child: IconButton(
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: MyColors.primary,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          ConditionalBuilder(
              condition: searchList.isNotEmpty,
              builder: (context) => Expanded(
                    child: SizedBox(
                      width: 100.w,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5.w)),
                          child: Row(
                            children: [
                              Text(searchList[index].name),
                              SizedBox(
                                width: 5.w,
                              ),
                              const Spacer(),
                              CustomButton(
                                  text: 'Attend',
                                  onPressed: () async {
                                    await ClassDetailsCubit.get(context)
                                        .addToAttendance(searchList[index],
                                            widget.currentClass);
                                  }),
                            ],
                          ),
                        ),
                        itemCount: itemCount,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 20.h,
                          );
                        },
                      ),
                    ),
                  ),
              fallback: (context) => Expanded(child: Container())),
        ],
      ),
    );
  }
}
