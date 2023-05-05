import 'package:attenda/core/colors.dart';
import 'package:attenda/history/models/history_model.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/students/models/student_history_model.dart';
import 'package:attenda/students/models/students_model.dart';
import 'package:attenda/whatsapp/view/widgets/whatsapp_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../classes/business_logic/classes_cubit/classes_cubit.dart';
import '../../../classes/view/widgets/custom_button.dart';
import '../../../classes/view/widgets/custom_text_field.dart';
import '../../../classes/view/widgets/toast.dart';
import '../../../whatsapp/business_logic/functions.dart';
import '../../business_logic/students_cubit/students_cubit.dart';
import '../widgets/scrollable_widget.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({Key? key, required this.student}) : super(key: key);
  final StudentsModel student;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();

  late String name;
  late String parentName;
  late String phone;
  late String parentPhone;
  late String className;

  late String nameMessage;
  late String phoneMessage;
  late String parentPhoneMessage;
  late String classNameMessage;

  late String hisOrHer;
  late List<String> classesNames;

  void _getStudentHistory() async {
    await StudentsCubit.get(context).getStudentHistory(widget.student.id);
  }

  @override
  void initState() {
    _getStudentHistory();
    classesNames = ClassesCubit.get(context).getClassesNames().toList();
    nameController.text = widget.student.name;
    phoneController.text = widget.student.phone;
    parentPhoneController.text = widget.student.parentPhone;
    parentNameController.text = widget.student.parentName;
    name = widget.student.name;
    parentName = widget.student.parentName;
    phone = widget.student.phone;
    parentPhone = widget.student.parentPhone;
    className = widget.student.className == "" && classesNames.isNotEmpty
        ? classesNames[0]
        : widget.student.className;
    hisOrHer = widget.student.gender == 'Male' ? 'his' : 'her';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    parentPhoneController.dispose();
    phoneController.dispose();
    parentPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Student',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: MyColors.primary),
        ),
        centerTitle: true,
        backgroundColor: MyColors.black,
      ),
      body: BlocListener<StudentsCubit, StudentsState>(
        listener: (context, state) {
          if (state is UpdateStudentError) {
            showErrorToast(context: context, message: state.error);
          }
          if (state is UpdateStudentSuccess) {
            showErrorToast(context: context, message: 'Updated Success');
          }
          if (state is GetStudentHistoryError) {
            showErrorToast(
                context: context, message: 'Error while loading history');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<StudentsCubit, StudentsState>(
              buildWhen: (previous, current) {
                return (current is UpdateStudentLoad ||
                    current is UpdateStudentSuccess ||
                    current is UpdateStudentError);
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 20.h),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  child: CustomTextFiled(
                                      hint: 'Enter Name',
                                      label: 'Name',
                                      controller: nameController,
                                      prefixIcon: Icons.person,
                                      inputType: TextInputType.name,
                                      onSave: (value) {
                                        name = value!;
                                      },
                                      onSubmit:(value)=>_update(),
                                      validate: (value) {
                                        return validation(value, 'name');
                                      }),
                                ),
                                SizedBox(
                                  width: 80.w,
                                  child: CustomTextFiled(
                                      hint: 'Phone Number',
                                      label: 'Phone',
                                      controller: phoneController,
                                      prefixIcon: Icons.phone,
                                      suffix: WhatsappButton(
                                          num: phoneController.text),
                                      inputType: TextInputType.phone,
                                      onSave: (value) {
                                        phone = value!;
                                      },
                                      onSubmit: (value)=>_update(),
                                      validate: (value) {
                                        return validation(
                                            value, 'phone number');
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: MyColors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r))),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  child: DropdownButton<dynamic>(
                                    value: className,
                                    isExpanded: true,
                                    underline: Container(),
                                    // menuMaxHeight: double.maxFinite,
                                    onChanged: (Object? newValue) {
                                      setState(() {
                                        className = newValue.toString();
                                      });
                                    },
                                    items: getMenuItems(context),
                                  ),
                                ),
                                SizedBox(
                                  width: 80.w,
                                  child: CustomTextFiled(
                                      hint: 'parent phone',
                                      label: 'parent phone',
                                      inputType: TextInputType.phone,
                                      prefixIcon: Icons.phone,
                                      controller: parentPhoneController,
                                      suffix: WhatsappButton(
                                          num: parentPhoneController.text),
                                      onSave: (value) {
                                        parentPhone = value!;
                                        print(parentPhone);
                                      },
                                      onSubmit: (value)=>_update(),
                                      validate: (value) {
                                        return validation(
                                            value, 'parent phone');
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 80.w,
                        height: 40.h,
                        child: CustomButton(
                            text: 'Update',
                            onPressed: () async {
                             _update();
                            })),
                    Divider(
                      thickness: 2.h,
                      color: Colors.grey,
                      endIndent: 3.w,
                      indent: 3.w,
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<StudentsCubit, StudentsState>(
              buildWhen: (previous, current) {
                return (current is GetStudentHistoryError ||
                    current is GetStudentHistoryLoad ||
                    current is GetStudentHistorySuccess ||
                    current is GetStudentHistoryError ||
                    current is GetStudentHistoryError ||
                    current is GetStudentHistoryError ||
                    current is UpdateStudentSuccess);
              },
              builder: (context, state) {
                if (state is GetStudentHistoryLoad) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: ScrollableWidget(
                      child: Column(
                        children: [
                          DataTable(
                              columns: getColumns(columnsLabels),
                              rows: getRows(
                                  StudentsCubit.get(context).studentHistory)),
                        ],
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _update() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (className != widget.student.className &&
          widget.student.className != "") {
        await StudentsCubit.get(context).changeStudentClass(
            widget.student.className, className, widget.student);
        // classNameMessage='the class name from ${widget.student.className} to $className';
        StudentsCubit.get(context).addToManageHistory(HistoryModel(
          userName: HomeCubit.get(context).userData!.name!,
          message:
              "has updated a student whose id ${widget.student.id} by changing $hisOrHer class name from ${widget.student.className} to $className ",
          date: DateFormat.yMEd().add_jms().format(DateTime.now()),
        ));
      }
      if (name != widget.student.name) {
        // nameMessage='$hisOrHer name from ${widget.student.name} to $name';
        StudentsCubit.get(context).addToManageHistory(HistoryModel(
          userName: HomeCubit.get(context).userData!.name!,
          message:
              "has updated a student whose id ${widget.student.id} by changing $hisOrHer name from ${widget.student.name} to $name ",
          date: DateFormat.yMEd().add_jms().format(DateTime.now()),
        ));
      }
      if (phone != widget.student.phone) {
        StudentsCubit.get(context).addToManageHistory(HistoryModel(
          userName: HomeCubit.get(context).userData!.name!,
          message:
              "has updated a student whose id ${widget.student.id} by changing $hisOrHer phone number from ${widget.student.phone} to $phone ",
          date: DateFormat.yMEd().add_jms().format(DateTime.now()),
        ));
      }
      if (parentPhone != widget.student.parentPhone) {
        StudentsCubit.get(context).addToManageHistory(HistoryModel(
          userName: HomeCubit.get(context).userData!.name!,
          message:
              "has updated a student whose id ${widget.student.id} by changing $hisOrHer parent phone from ${widget.student.parentPhone} to $parentPhone ",
          date: DateFormat.yMEd().add_jms().format(DateTime.now()),
        ));
      }
      await StudentsCubit.get(context).editStudentInfo(StudentsModel(
        name: name,
        phone: phone,
        parentName: widget.student.parentName,
        className: className,
        parentPhone: parentPhone,
        id: widget.student.id,
        gender: widget.student.gender,
      ));
      StudentsCubit.get(context).getAllStudents();
    }
  }

  String? validation(String? value, String text) {
    if (value!.isEmpty) {
      return 'Enter the $text';
    } else {
      return null;
    }
  }

  List<DropdownMenuItem> getMenuItems(BuildContext context) {
    List<DropdownMenuItem> menuItems = classesNames
        .map((className) => DropdownMenuItem(
              value: className,
              child: Text(className),
            ))
        .toList();
    return menuItems;
  }

  List<String> columnsLabels = [
    'whatsapp',
    'class date',
    'class name',
    'quiz status',
    'quiz degree',
    'HW status',
    'HW degree',
    'pay',
    'comment',
  ];

  List<DataColumn> getColumns(List<String> columnsLabels) {
    return columnsLabels
        .map((label) => DataColumn(label: Text(label)))
        .toList();
  }

  List<DataRow> getRows(List<StudentHistory> histories) {
    List<DataRow> records = [];
    histories.forEach((history) {
      records.add(DataRow(cells: [
        DataCell(SizedBox(
            width: 15.w,
            child: WhatsappButton(
                num: parentPhone,
                message:MyFunctions.makeTemplate(history, context, name)))),
        DataCell(
          Text(DateFormat.yMMMd().format(DateTime.parse(history.classDate))),
        ),
        DataCell(
          Text(history.className),
        ),
        DataCell(
          Text(history.quizStatus.toString()),
        ),
        DataCell(
          Text(history.quizDegree),
        ),
        DataCell(
          Text(history.hwStatus.toString()),
        ),
        DataCell(Text(history.hwDegree)),
        DataCell(Text(history.costPurchased.toString())),
        DataCell(
          Text(history.comment),
        ),
      ]));
    });
    return records;
  }
}
