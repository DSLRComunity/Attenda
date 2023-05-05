import 'package:attenda/core/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../classes/view/widgets/custom_button.dart';
import '../../../core/routing/routes.dart';
import '../../business_logic/students_cubit/students_cubit.dart';
import '../../models/students_model.dart';
import '../widgets/scrollable_widget.dart';
import '../widgets/show_student_dialog.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  void _getStudents() async {
    await StudentsCubit.get(context).getAllStudents();
  }

  @override
  void initState() {
    _getStudents();
    super.initState();
  }

  List<String> columnsLabels = [
    'remove',
    'Info',
    'Id',
    'Name',
    'phone',
    'parent phone',
    'QR code',
    'class name',
  ];

  List<DataColumn> getColumns(List<String> columnsLabels) {
    return columnsLabels
        .map((label) => DataColumn(label: Text(label)))
        .toList();
  }

  List<DataRow> getRows(List<StudentsModel> students) {
    return students
        .map((student) => DataRow(cells: [
              DataCell(IconButton(
                onPressed: () async {
                  await StudentsCubit.get(context)
                      .removeStudent(student.id, student.className, context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: MyColors.primary,
                ),
              )),
              DataCell(
                Image.asset(
                  '${(kDebugMode && kIsWeb) ? "" : "assets/"}images/picture.png',
                  width: 15.w,
                  fit: BoxFit.fitHeight,
                ),
                onTap: () {
                  showStudentDialog(
                      context, student.id, student.name, student.className);
                },
              ),
              DataCell(
                  Text(
                    student.id,
                    style: TextStyle(height: 1.h),
                  ), onDoubleTap: () {
                navigateToEditStudent(student);
              }),
              DataCell(Text(student.name, style: TextStyle(height: 1.h)),
                  onDoubleTap: () {
                navigateToEditStudent(student);
              }),
              DataCell(Text(student.phone, style: TextStyle(height: 1.h)),
                  onDoubleTap: () {
                navigateToEditStudent(student);
              }),
              DataCell(Text(student.parentPhone, style: TextStyle(height: 1.h)),
                  onDoubleTap: () {
                navigateToEditStudent(student);
              }),
              DataCell(
                  SizedBox(
                    width: 20.w,
                    child: QrImage(
                      data: student.name,
                      version: QrVersions.auto,
                    ),
                  ), onDoubleTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AlertDialog(
                              backgroundColor: Colors.white,
                              content: Center(
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: QrImage(
                                    data: student.name,
                                    version: QrVersions.auto,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }),
              DataCell(Text(student.className, style: TextStyle(height: 1.h)),
                  onDoubleTap: () {}),
            ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.h),
          child: Align(
            alignment: Alignment.topRight,
            child: CustomButton(
              text: 'Add Student',
              onPressed: () {
                Navigator.pushNamed(context, Routes.newStudentRoute);
              },
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<StudentsCubit, StudentsState>(
              builder: (context, state) {
            return StudentsCubit.get(context).students == null
                ? Container()
                : ScrollableWidget(
                    child: StudentsCubit.get(context).students == null
                        ? Container()
                        : DataTable(
                            columns: getColumns(columnsLabels),
                            rows: getRows(StudentsCubit.get(context).students!),
                          ),
                  );
          }),
        ),
      ],
    );
  }

  void navigateToEditStudent(StudentsModel student) {
    Navigator.pushNamed(context, Routes.editStudentRoute, arguments: student);
  }
}
