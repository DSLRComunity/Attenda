import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:attenda/students/models/students_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/colors.dart';
import '../../business_logic/class_details_cubit.dart';

class ClassStudents extends StatefulWidget {
  const ClassStudents({Key? key, required this.currentClass}) : super(key: key);
  final ClassModel currentClass;

  @override
  State<ClassStudents> createState() => _ClassStudentsState();
}

class _ClassStudentsState extends State<ClassStudents> {
  final _scrollController=ScrollController();
 final TextEditingController searchController=TextEditingController();
  List<StudentsModel> searchList = [];
  bool searched = false;
  int itemCount = 0;
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
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
                child: SizedBox(
                  child: TextFormField(
                    onChanged: (value) {
                      searched = true;
                      setState(() {
                        searchList = StudentsCubit.get(context).students!
                            .where((student) => student.id.startsWith(value)||student.name.startsWith(value))
                            .toList();
                        itemCount = searchList.length;
                      });
                    },
                    onTapOutside: (event) {
                      setState(() {
                        searched=false;
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
                        hintText: "Search by name or id",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 16)),
                  ),
                ),
              ),
              Expanded(
                child: ImprovedScrolling(
                  scrollController: _scrollController,
                  enableKeyboardScrolling: true,
                  keyboardScrollConfig: KeyboardScrollConfig(
                    arrowsScrollAmount: 100,
                    homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
                      return const Duration(milliseconds: 100);
                    },
                    endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
                      return const Duration(milliseconds: 2000);
                    },
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility:true ,
                    scrollbarOrientation: ScrollbarOrientation.left,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: EdgeInsets.symmetric( horizontal: 3.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:searchController.text.isNotEmpty? searchList.map((student) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Row(
                              children: [
                                FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(student.name)),
                                const Spacer(),
                                AttendButton(
                                    currentClass: widget.currentClass,
                                    student: student),
                              ],
                            ),
                          )).toList()
                              :
                          ClassDetailsCubit.get(context).classStudents.map((student) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.h),
                                    child: Row(
                                      children: [
                                        FittedBox(
                                            fit:BoxFit.fitWidth,
                                            child: Text(student.name)),
                                        const Spacer(),
                                        AttendButton(
                                            currentClass: widget.currentClass,
                                            student: student),
                                      ],
                                    ),
                                  )).toList(), //getStudentsNames(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class AttendButton extends StatefulWidget {
  const AttendButton({Key? key, required this.currentClass, required this.student}) : super(key: key);
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
            await ClassDetailsCubit.get(context).addToAttendance(widget.student, widget.currentClass,context);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
