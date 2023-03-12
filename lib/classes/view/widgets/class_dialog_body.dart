import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../business_logic/add_class_cubit/add_classes_cubit.dart';
import '../../business_logic/classes_cubit/classes_cubit.dart';
import '../../models/class_model.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class ClassDialogBody extends StatefulWidget {
  const ClassDialogBody({Key? key}) : super(key: key);

  @override
  State<ClassDialogBody> createState() => _ClassDialogBodyState();
}

class _ClassDialogBodyState extends State<ClassDialogBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController centerNameController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController iterativeController = TextEditingController();

  late  String centerName;
  late  double price;
  late  DateTime dateTime;
  late  String time;
  late  String region;
  late int iterative;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AddClassCubit, AddClassState>(
      listener: (context, state) {
        if (state is AddClassSuccess) {
          showSuccessToast(
              context: context, message: 'Class Added Successfully');
          dateController.clear();
          timeController.clear();
          priceController.clear();
          centerNameController.clear();
          regionController.clear();
          iterativeController.clear();
        }
        if (state is AddClassError) {
          showErrorToast(context: context, message: state.error);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Add Class '),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFiled(
                        hint: 'date',
                        label: 'date',
                        prefixIcon: Icons.date_range,
                        controller: dateController,
                        inputType: TextInputType.datetime,
                        onSave: (value) {},
                        onTab: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2026-02-12'),
                          ).then((value) {
                            if(value==null){
                              dateController.text=DateFormat.yMMMd().format(DateTime.now());
                              dateTime=DateTime.now();
                            }else{
                            dateController.text =
                            DateFormat.yMMMd().format(value);
                            dateTime = value;
                            }
                          });
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the data !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFiled(
                        hint: 'time',
                        label: 'Time',
                        inputType: TextInputType.datetime,
                        prefixIcon: Icons.timelapse,
                        controller: timeController,
                        onSave: (value) {
                          time = value!;
                        },
                        onTab: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                                if(value==null){
                                  timeController.text=TimeOfDay.now().format(context);
                                }else{
                                  timeController.text = value.format(context);
                                }
                          });
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the time !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFiled(
                        hint: 'region',
                        label: 'Region',
                        prefixIcon: Icons.place,
                        controller: regionController,
                        onSave: (value) {
                          region = value!;
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the region !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFiled(
                        hint: 'center name',
                        label: 'Center Name',
                        prefixIcon: Icons.message,
                        controller: centerNameController,
                        onSave: (value) {
                          centerName = value!;
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the center name !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFiled(
                        hint: 'class price',
                        label: 'Price',
                        controller: priceController,
                        inputType: TextInputType.number,
                        prefixIcon: Icons.date_range,
                        onSave: (value) {
                          price = double.parse(value!);
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the price !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFiled(
                        hint: 'class times in the month',
                        label: 'Class Times',
                        prefixIcon: Icons.date_range,
                        controller: iterativeController,
                        onSave: (value) {
                          iterative = int.parse(value!);
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the class times !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    state is AddClassLoad
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: 'Add',
                            onPressed: () async{
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                               await AddClassCubit.get(context).addClass(
                                    ClassModel(
                                    date: dateTime,
                                    time: time,
                                    region: region,
                                    classPrice: price,
                                    centerName: centerName,
                                    iteration: iterative,
                                    maxHwDegree: 0.0,
                                      moneyCollected: 0.0,
                                      maxQuizDegree: 0.0,
                                      numOfAttendants: 0,
                                    ));
                                ClassesCubit.get(context).getAllClasses();
                              }
                            }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    priceController.dispose();
    centerNameController.dispose();
    regionController.dispose();
    iterativeController.dispose();
    super.dispose();
  }
}
