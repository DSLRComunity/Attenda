import 'package:attenda/class_details/view/widgets/attendance_dialog.dart';
import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../classes/models/class_model.dart';
import '../../../core/colors.dart';
import '../../business_logic/class_details_cubit.dart';

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

  @override
  void initState() {
    date = widget.currentClass.date;
    time = widget.currentClass.time;
    dateController.text = DateFormat.yMMMd().format(widget.currentClass.date);
    placeController.text = widget.currentClass.centerName;
    priceController.text = widget.currentClass.classPrice.toString();
    timeController.text = widget.currentClass.time;
    // attendanceController.text = widget.currentClass.students.length.toString();

    super.initState();
  }

  final TextEditingController dateController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController attendanceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassDetailsCubit,ClassDetailsState>(
      listener: (context, state) {
        if(state is UpdateDetailsSuccess){
          showSuccessToast(context: context, message: 'Updated Successfully');
        }else if(state is UpdateDetailsError){
          showErrorToast(context: context, message: 'Error in update');
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text('Date: '),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            child: TextFormField(
                              controller: dateController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2026-02-12'),
                                ).then((value) {
                                  if (value == null) {
                                    dateController.text = DateFormat.yMMMd()
                                        .format(widget.currentClass.date);
                                    date = widget.currentClass.date;
                                  } else {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                    date = value;
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                              ),
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
                        children: [
                          const Text('Place: '),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            child: TextFormField(
                                controller: placeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: MyColors.grey),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: MyColors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: MyColors.grey),
                                  ),
                                ),
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
                        children: [
                          const Text('Price: '),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            child: TextFormField(
                              controller: priceController,
                              onSaved: (value) {
                                price = double.parse(value!);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20.w, child: const Text('Time: ')),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            child: TextFormField(
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
                                    timeController.text = value.format(context);
                                  }
                                });
                              },
                              onSaved: (value) {
                                time = value!;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                              ),
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
                        children: [
                          SizedBox(
                              width: 20.w, child: const Text('Attendance: ')),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            child: TextFormField(
                              enabled: false,
                              controller: attendanceController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: MyColors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 28.w,
                          ),
                          SizedBox(
                            width: 50.w,
                            height: 40.h,
                            child:
                            BlocBuilder<ClassDetailsCubit,ClassDetailsState>(
                              builder: (context, state) {
                                if(state is UpdateDetailsLoad){
                                  return const Center(child: CircularProgressIndicator(),);
                                }else{
                                  return CustomButton(
                                      text: 'Update',
                                      onPressed: () async{
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          await ClassDetailsCubit.get(context).updateClassDetails(
                                              ClassModel(
                                                  date: date,
                                                  time: time,
                                                  region: widget.currentClass.region,
                                                  classPrice: price,
                                                  centerName: place,
                                                  iteration: widget.currentClass.iteration));
                                          await ClassesCubit.get(context).getAllClasses();
                                        }
                                      });
                                }
                              },
                            ),
                          ),
                        ],
                      ), // Button
                    ],
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Column(
                    children: [
                      CustomButton(
                          text: 'Manual Attendance',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AttendanceDialog(
                                      attendanceStudents: StudentsCubit.get(context).students!, currentClass: widget.currentClass);
                                });
                          }),
                      SizedBox(
                        height: 8.h,
                      ),
                      SizedBox(
                        width: 70.w,
                        child: TextFormField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: MyColors.primary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: MyColors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: MyColors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomButton(text: 'Send', onPressed: () {})
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
