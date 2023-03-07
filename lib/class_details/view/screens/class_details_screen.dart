import 'package:attenda/class_details/view/widgets/class_details.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/students/models/student_history_model.dart';
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
  void _getClassStudents() async {
    await ClassDetailsCubit.get(context).getClassStudents(widget.currentClass);
    await ClassDetailsCubit.get(context)
        .getClassAttendantStudents(widget.currentClass);
    await ClassDetailsCubit.get(context).getClassHistory(widget.currentClass);
  }

  @override
  void initState() {
    _getClassStudents();
    // quizStatus = quizStatuses[0];
    // hwStatus = false;
    super.initState();
  }

  late String quizDegree;
  // late dynamic quizStatus;
  // late dynamic hwStatus;
  late String hwDegree;
  late String comment;
  late String pay;

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
                            rows: getRows(ClassDetailsCubit.get(context)
                                .classHistory), //getRows(ClassDetailsCubit.get(context).classStudents!),
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
                          children: ClassDetailsCubit.get(context)
                              .classStudents
                              .map((student) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                                child: Row(
                                      children: [
                                        Text(student.name),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        const Spacer(),
                                        CustomButton(
                                            text: 'Attend',
                                            onPressed: () async {
                                              await ClassDetailsCubit.get(context)
                                                  .addToAttendance(student,
                                                      widget.currentClass);
                                            }),
                                      ],
                                    ),
                              ))
                              .toList(), //getStudentsNames(context),
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

  List<dynamic> quizStatuses = [
    'لم يؤدي',
    'بداية الحصة',
    'نهاية الحصة',
  ];

  List<dynamic> hwStatuses = [
    false,
    true,
  ];
  List<String> columnsLabels = [
    'name',
    'quiz status',
    'quiz degree',
    'HW status',
    'HW degree',
    'comment',
    'Pay',
  ];

  List<DataColumn> getColumns(List<String> columnsLabels) {
    return columnsLabels.map((label) => DataColumn(label: Text(label))).toList();
  }

  List<DataRow> getRows(List<StudentHistory> histories) {
    List<DataRow> historyList = [];
    histories.forEach((history) {
      print(history.quizStatus);
      historyList.add(DataRow(cells: [
        DataCell(
          TextFormField(
            enabled: false,
            initialValue: history.name,
          ),
        ),
        DataCell(
          DropdownButton<dynamic>(
            value:history.quizStatus,
            onChanged: (Object? newValue) async {
              setState(() {
                history.quizStatus = newValue;
              });
              await ClassDetailsCubit.get(context).updateHistory(
                  widget.currentClass,
                  history.id,
                  StudentHistory(
                          name: history.name,
                          id: history.id,
                          comment: history.comment,
                          classDate: history.classDate,
                          className: history.className,
                          costPurchased: history.costPurchased,
                          hwDegree: history.hwDegree,
                          hwStatus: history.hwStatus,
                          quizDegree: history.quizDegree,
                          quizStatus: history.quizStatus)
                      .toJson());
            },
            items: <DropdownMenuItem<dynamic>>[
              const DropdownMenuItem(
                value: 'لم يؤدي',
                child: Text('لم يؤدي'),
              ),
              DropdownMenuItem(
                  value: quizStatuses[1],
                  child: const Text('بداية الحصة')),
              DropdownMenuItem(
                value: quizStatuses[2],
                child: const Text('نهاية الحصة'),
              ),
            ],
          ),
        ),
        DataCell(
            TextFormField(
              initialValue: history.quizDegree,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (val) async {
                ClassDetailsCubit.get(context).updateHistory(
                    widget.currentClass,
                    history.id,
                    StudentHistory(
                            name: history.name,
                            id: history.id,
                            comment: history.comment,
                            classDate: history.classDate,
                            className: history.className,
                            costPurchased: history.costPurchased,
                            hwDegree: history.hwDegree,
                            hwStatus: history.hwStatus,
                            quizDegree: val,
                            quizStatus: history.quizStatus)
                        .toJson());
              },
            ),
            showEditIcon: true),
        DataCell(
          DropdownButton<dynamic>(
            value: history.hwStatus,
            onChanged: (Object? newValue) {
              setState(() {
                history.hwStatus = newValue;
                ClassDetailsCubit.get(context).updateHistory(
                    widget.currentClass,
                    history.id,
                    StudentHistory(
                            name: history.name,
                            id: history.id,
                            comment: history.comment,
                            classDate: history.classDate,
                            className: history.className,
                            costPurchased: history.costPurchased,
                            hwDegree: history.hwDegree,
                            hwStatus: history.hwStatus,
                            quizDegree: history.quizDegree,
                            quizStatus: history.quizStatus)
                        .toJson());
              });
            },
            items: <DropdownMenuItem<dynamic>>[
              DropdownMenuItem(
                value: hwStatuses[0],
                child: const Text(
                  'No',
                ),
              ),
              DropdownMenuItem(
                value: hwStatuses[1],
                child: const Text('Yes'),
              ),
            ],
          ),
        ),
        DataCell(
            TextFormField(
              initialValue: history.hwDegree,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (val) async {
                ClassDetailsCubit.get(context).updateHistory(
                    widget.currentClass,
                    history.id,
                    StudentHistory(
                            name: history.name,
                            id: history.id,
                            comment: history.comment,
                            classDate: history.classDate,
                            className: history.className,
                            costPurchased: history.costPurchased,
                            hwDegree: val,
                            hwStatus: history.hwStatus,
                            quizDegree: history.quizDegree,
                            quizStatus: history.quizStatus)
                        .toJson());
              },
            ),
            showEditIcon: true),
        DataCell(
            TextFormField(
              initialValue: history.comment,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (val) async {
                ClassDetailsCubit.get(context).updateHistory(
                    widget.currentClass,
                    history.id,
                    StudentHistory(
                            name: history.name,
                            id: history.id,
                            comment: val,
                            classDate: history.classDate,
                            className: history.className,
                            costPurchased: history.costPurchased,
                            hwDegree: history.hwDegree,
                            hwStatus: history.hwStatus,
                            quizDegree: history.quizDegree,
                            quizStatus: history.quizStatus)
                        .toJson());
              },
            ),
            showEditIcon: true),
        DataCell(
            TextFormField(
              initialValue: history.costPurchased.toString(),
              keyboardType: TextInputType.name,
              onFieldSubmitted: (val) async {
                ClassDetailsCubit.get(context).updateHistory(
                    widget.currentClass,
                    history.id,
                    StudentHistory(
                            name: history.name,
                            id: history.id,
                            comment: history.comment,
                            classDate: history.classDate,
                            className: history.className,
                            costPurchased: double.parse(val),
                            hwDegree: history.hwDegree,
                            hwStatus: history.hwStatus,
                            quizDegree: history.quizDegree,
                            quizStatus: history.quizStatus)
                        .toJson());
              },
            ),
            showEditIcon: true),
      ]));
    });
    return historyList;
  }

}
