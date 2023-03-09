import 'dart:convert';
import 'package:attenda/class_details/view/widgets/attendance_dialog.dart';
import 'package:attenda/class_details/view/widgets/my_border.dart';
import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import '../../../classes/models/class_model.dart';
import '../../../students/models/student_history_model.dart';
import '../../business_logic/class_details_cubit.dart';
import "package:universal_html/html.dart" show AnchorElement;

class ClassDetails extends StatefulWidget {
  ClassDetails({Key? key, required this.currentClass}) : super(key: key);

  ClassModel currentClass;

  @override
  State<ClassDetails> createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  late DateTime date;
  late String time;
  late String place;
  late double price;
  late double maxQuizDegree;
  late double maxHwDegree;
  late double moneyCollected;

  @override
  void initState() {
    date = widget.currentClass.date;
    time = widget.currentClass.time;
    moneyCollected = widget.currentClass.moneyCollected;
    dateController.text = DateFormat.yMMMd().format(widget.currentClass.date);
    placeController.text = widget.currentClass.centerName;
    priceController.text = widget.currentClass.classPrice.toString();
    timeController.text = widget.currentClass.time;
    maxQuizDegreeController.text = widget.currentClass.maxQuizDegree.toString();
    maxHwDegreeController.text = widget.currentClass.maxHwDegree.toString();
    moneyCollectedController.text = widget.currentClass.moneyCollected.toString();
    attendanceController.text = ClassDetailsCubit.get(context).numOfAttendantStudents.toString();
    ClassDetailsCubit.get(context).getTotalMoney();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    placeController.dispose();
    priceController.dispose();
    attendanceController.dispose();
    timeController.dispose();
    maxQuizDegreeController.dispose();
    maxHwDegreeController.dispose();
    moneyCollectedController.dispose();
    super.dispose();
  }

  final TextEditingController dateController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController attendanceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController maxQuizDegreeController = TextEditingController();
  final TextEditingController maxHwDegreeController = TextEditingController();
  final TextEditingController moneyCollectedController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    print(ClassDetailsCubit.get(context).numOfAttendantStudents.toString());
    attendanceController.text = ClassDetailsCubit.get(context).numOfAttendantStudents.toString();
    moneyCollectedController.text=ClassDetailsCubit.get(context).totalMoney.toString();
    return BlocListener<ClassDetailsCubit, ClassDetailsState>(
      listener: (context, state) {
        if (state is UpdateDetailsSuccess) {
          showSuccessToast(context: context, message: 'Updated Successfully');
        } else if (state is UpdateDetailsError) {
          showErrorToast(context: context, message: 'Error in update');
        }
      },
      child: BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
        buildWhen: (previous, current) => (current is UpdateDetailsSuccess ||
            current is UpdateDetailsError ||
            current is UpdateDetailsLoad ||
            current is AddToTotalMoney),
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Container(
              color: isUpdate ? Colors.grey : Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Date: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      controller: dateController,
                                      enabled: isUpdate,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2026-02-12'),
                                        ).then((value) {
                                          if (value == null) {
                                            dateController.text =
                                                DateFormat.yMMMd().format(
                                                    widget.currentClass.date);
                                            date = widget.currentClass.date;
                                          } else {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value);
                                            date = value;
                                          }
                                        });
                                      },
                                      decoration: myBorder(isUpdate),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'enter the date';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Max\nquiz: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      enabled: isUpdate,
                                      controller: maxQuizDegreeController,
                                      decoration: myBorder(isUpdate),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter the max quiz degree';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        maxQuizDegree = double.parse(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Price: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      enabled: isUpdate,
                                      controller: priceController,
                                      onSaved: (value) {
                                        price = double.parse(value!);
                                      },
                                      decoration: myBorder(isUpdate),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Time: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      enabled: isUpdate,
                                      controller: timeController,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          if (value == null) {
                                            timeController.text =
                                                TimeOfDay.now().format(context);
                                          } else {
                                            timeController.text =
                                                value.format(context);
                                          }
                                        });
                                      },
                                      onSaved: (value) {
                                        time = value!;
                                      },
                                      decoration: myBorder(isUpdate),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'enter the date';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Max HW:')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                        enabled: isUpdate,
                                        controller: maxHwDegreeController,
                                        decoration: myBorder(isUpdate),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter the max HW degree';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          maxHwDegree = double.parse(value!);
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Money purchased: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: moneyCollectedController,
                                      decoration: myBorder(isUpdate),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Place: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                        enabled: isUpdate,
                                        controller: placeController,
                                        decoration: myBorder(isUpdate),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter the place';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) {
                                          place = value!;
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Attendance: ')),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: attendanceController,
                                      decoration: myBorder(isUpdate),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              text: 'Manual Attendance',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AttendanceDialog(
                                          attendanceStudents:
                                              StudentsCubit.get(context)
                                                  .students!,
                                          currentClass: widget.currentClass);
                                    });
                              }),
                          CustomButton(
                              text: 'Excel',
                              onPressed: () async {
                                await createExcel(ClassDetailsCubit.get(context)
                                    .classHistory);
                                // await DioHelper.postData(path: '/111973761834007/messages', data: WhatsappModel(phoneNumber: '201001700373', message: messageController.text));
                              }),
                          BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
                            builder: (context, state) {
                              if (state is UpdateDetailsLoad) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!isUpdate) {
                                return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isUpdate = true;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: MyColors.primary,
                                    ));
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 5.h),
                                  child: CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: isUpdate
                                        ? Colors.white
                                        : Colors.transparent,
                                    child: IconButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            await ClassDetailsCubit.get(context)
                                                .updateClassDetails(ClassModel(
                                              date: date,
                                              time: time,
                                              region:
                                                  widget.currentClass.region,
                                              classPrice: price,
                                              centerName: place,
                                              iteration:
                                                  widget.currentClass.iteration,
                                              maxQuizDegree: maxQuizDegree,
                                              maxHwDegree: maxHwDegree,
                                              moneyCollected: moneyCollected,
                                            ));
                                            await ClassesCubit.get(context)
                                                .getAllClasses();
                                            setState(() {
                                              isUpdate = false;
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          color: MyColors.primary,
                                        )),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> createExcel(List<StudentHistory> studentsHistory) async {
    excel.Worksheet sheet;
    final excel.Workbook workbook = excel.Workbook();
    sheet = workbook.worksheets[0];
    int index = 1;
    studentsHistory.forEach((history) {
      sheet.getRangeByName('A$index').setText(history.name);
      sheet.getRangeByName('B$index').setText(history.quizStatus.toString());
      sheet.getRangeByName('C$index').setText(history.quizDegree);
      sheet.getRangeByName('D$index').setText(history.hwStatus.toString());
      sheet.getRangeByName('E$index').setText(history.hwDegree);
      sheet.getRangeByName('F$index').setText(history.comment);
      sheet.getRangeByName('G$index').setNumber(history.costPurchased);
      index++;
    });
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'output.xlsx')
        ..click();
    }
  }

  bool isNumeric(String text) {
    return double.tryParse(text) != null;
  }
}
