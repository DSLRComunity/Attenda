import 'package:attenda/class_details/view/widgets/class_details.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../classes/models/class_model.dart';
import '../../../classes/view/widgets/custom_button.dart';
import '../../../classes/view/widgets/get_day_function.dart';
import '../../../students/view/widgets/scrollable_widget.dart';
import '../../business_logic/class_details_cubit.dart';

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({Key? key, required this.currentClass})
      : super(key: key);

  final ClassModel currentClass;

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  void _getClassStudents()async{
    await ClassDetailsCubit.get(context).getClassStudents(widget.currentClass);
  }

  @override
  void initState() {
    _getClassStudents();
    super.initState();
  }

  List<String> columnsLabels = [
    'name',
    'quiz status',
    'quiz degree',
    'HW status',
    'HW degree',
    'comment',
    'Pay',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        title: Text(getClassName(widget.currentClass,),style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.primary),),
      ),
      body: BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .45,
                      child: ClassDetails(
                        currentClass: widget.currentClass,
                      ),
                    ),
                    Divider(
                      thickness: 2.h,
                      color: Colors.black,
                    ),
                    ScrollableWidget(
                      child: Column(
                        children: [
                          DataTable(
                            columns: getColumns(columnsLabels),
                            rows: const <DataRow>[],              //getRows(ClassDetailsCubit.get(context).classStudents!),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:ClassDetailsCubit.get(context).classStudents
                              .map((student) => Row(
                            children: [
                              Text(student.name),
                              SizedBox(
                                width: 5.w,
                              ),
                              const Spacer(),
                              CustomButton(
                                  text: 'Attend',
                                  onPressed: () async{
                                    await ClassDetailsCubit.get(context).addToAttendance(student,widget.currentClass);
                                  }),
                            ],
                          ))
                              .toList(),//getStudentsNames(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columnsLabels) {
    return columnsLabels
        .map((label) => DataColumn(label: Text(label)))
        .toList();
  }
  //
  // List<DataRow> getRows(List<StudentsModel> students) {
  //   List<DataRow> historyList = [];
  //   students.forEach((student) {
  //     if (student.studentHistory![widget.currentClass.date.toString()] !=
  //         null) {
  //       historyList.add(DataRow(cells: [
  //         DataCell(
  //           Text(student.firstName),
  //         ),
  //         const DataCell(
  //           QuizDropDown(menuItems: [
  //             DropdownMenuItem(
  //               value: false,
  //               child: Text('No'),
  //             ),
  //             DropdownMenuItem(
  //               value: true,
  //               child: Text('yes'),
  //             ),
  //           ]),
  //         ),
  //         DataCell(
  //             Text(student.studentHistory![widget.currentClass.date.toString()]!
  //                 .quizDegree),
  //             showEditIcon: student
  //                 .studentHistory![widget.currentClass.date.toString()]!
  //                 .quizStatus, onTap: () {
  //           if (student.studentHistory![widget.currentClass.date.toString()]!
  //               .quizStatus) {
  //             editQuizDegree(student);
  //           }
  //         }),
  //         const DataCell(
  //           QuizDropDown(menuItems: [
  //             DropdownMenuItem(
  //               value: false,
  //               child: Text('No'),
  //             ),
  //             DropdownMenuItem(
  //               value: true,
  //               child: Text('yes'),
  //             ),
  //           ]),
  //         ),
  //         DataCell(
  //             Text(student.studentHistory![widget.currentClass.date.toString()]!
  //                 .hwDegree),
  //             showEditIcon: student
  //                 .studentHistory![widget.currentClass.date.toString()]!
  //                 .hwStatus, onTap: () {
  //           if (student.studentHistory![widget.currentClass.date.toString()]!
  //               .hwStatus) {
  //             ClassDetailsCubit.get(context)
  //                 .editHwDegree(student, widget.currentClass, context);
  //           }
  //         }),
  //         DataCell(
  //             Text(student.studentHistory![widget.currentClass.date.toString()]!
  //                 .comment),
  //             showEditIcon: true, onTap: () {
  //           ClassDetailsCubit.get(context)
  //               .editComment(student, widget.currentClass, context);
  //         }),
  //         DataCell(
  //             Text(student.studentHistory![widget.currentClass.date.toString()]!
  //                 .costPurchased
  //                 .toString()),
  //             showEditIcon: true, onTap: () {
  //           ClassDetailsCubit.get(context)
  //               .editPayment(student, widget.currentClass, context);
  //         }),
  //       ]));
  //     } else {
  //       historyList.add(DataRow(cells: [
  //         DataCell(Container()),
  //         DataCell(Container()),
  //         DataCell(Container()),
  //         DataCell(Container()),
  //         DataCell(Container()),
  //         DataCell(Container()),
  //         DataCell(Container()),
  //       ]));
  //     }
  //   });
  //   return historyList;
  // }
  //
  // Future editQuizStatus(StudentsModel editStudent, bool quizStatus) async {
  //   setState(() => widget.currentClass.students =
  //           widget.currentClass.students.map((student) {
  //         final isEditedStudent = student == editStudent;
  //         if (isEditedStudent) {
  //           return student.edit(
  //               quizStatus: quizStatus, date: widget.currentClass.date);
  //         } else {
  //           return student;
  //         }
  //       }).toList());
  // }
  //
  // Future editHwStatus(StudentsModel editStudent, bool hwStatus) async {
  //   setState(() => widget.currentClass.students =
  //           widget.currentClass.students.map((student) {
  //         final isEditedStudent = student == editStudent;
  //         if (isEditedStudent) {
  //           return student.edit(
  //               hwStatus: hwStatus, date: widget.currentClass.date);
  //         } else {
  //           return student;
  //         }
  //       }).toList());
  // }
  //
  // Future editQuizDegree(StudentsModel editStudent) async {
  //   // List<StudentModel>students= widget.currentClass.students;
  //   final quizDegree = await showTextDialog(
  //     context,
  //     title: 'Change quiz degree',
  //     value: editStudent
  //         .studentHistory!['${widget.currentClass.date}']!.quizDegree,
  //   );
  //   setState(() => widget.currentClass.students =
  //           widget.currentClass.students.map((student) {
  //         final isEditedStudent = student == editStudent;
  //         if (isEditedStudent) {
  //           return student.edit(
  //               quizDegree: quizDegree, date: widget.currentClass.date);
  //         } else {
  //           return student;
  //         }
  //       }).toList());
  // }
  //

  // List<Row> getStudentsNames(BuildContext context) {
  //   if (ClassDetailsCubit.get(context).classStudents!.isEmpty) {
  //     return [];
  //   } else {
  //     return ClassDetailsCubit.get(context).classStudents!
  //         .map((student) => Row(
  //               children: [
  //                 Text('${student.firstName} ${student.lastName}'),
  //                 SizedBox(
  //                   width: 5.w,
  //                 ),
  //                 const Spacer(),
  //                 CustomButton(
  //                     text: 'Attend',
  //                     onPressed: () {
  //                       ClassDetailsCubit.get(context).editStudentAttendance(
  //                           widget.currentClass,
  //                           student,
  //                           widget.currentClass.date,
  //                           context);
  //                     }),
  //               ],
  //             ))
  //         .toList();
  //   }
  // }
}
