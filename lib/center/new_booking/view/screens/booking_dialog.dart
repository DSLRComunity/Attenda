import 'dart:async';
import 'package:attenda/center/new_booking/business_logic/booking_cubit.dart';
import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/new_booking/models/new_booking_model.dart';
import 'package:attenda/center/new_booking/view/widgets/teacher_search_field.dart';
import 'package:attenda/center/rooms/models/room_model.dart';
import 'package:attenda/center/new_teacher/view/screens/new_teacher_screen.dart';
import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../widgets/booking_text_field.dart';

class BookingDialog extends StatefulWidget {
  const BookingDialog({Key? key, required this.centerHomeCubit})
      : super(key: key);
  final CenterHomeCubit centerHomeCubit;

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  Timer? timer;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final teacherNameController = TextEditingController();
  final teacherIdController = TextEditingController();
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final appointmentRecursionController = TextEditingController();
  final subjectController=TextEditingController();
  final priceController=TextEditingController();


  late RoomModel chooseRoom;
  late String teacherId;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late String date;
  late String price;
  late String payMethod;
  late String duration;
  late String recurrence;
  late String subject;

  void _checkAvailableRooms() {
    if (BookingCubit.get(context).rooms.isNotEmpty) {
      timer!.cancel();
      chooseRoom = BookingCubit.get(context).rooms[0];
      print(chooseRoom.name);
      setState(() {});
    }
  }

  void _getInitialData() async {
    chooseRoom=RoomModel(name: 'name', id: '');
    await BookingCubit.get(context).getMyRooms(context);
    BookingCubit.get(context)
        .teacherPagingController
        .addPageRequestListener((pageKey) {
      BookingCubit.get(context).getMyTeachers(context,pageKey);
    });
  }

  @override
  void initState() {
    _getInitialData();
    payMethod='1';
    timer = Timer.periodic(const Duration(microseconds: 500), (timer)=>_checkAvailableRooms());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is SearchForTeacherError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Not found'),
            duration: Duration(seconds: 2),
            backgroundColor: MyColors.black,
          ));
          teacherNameController.text = '';
          teacherIdController.text = '';
        }
        if (state is SearchForTeacherSuccess) {
          teacherNameController.text =
              BookingCubit.get(context).searchedTeacher[0].name;
          teacherIdController.text = searchController.text;
          setState(() {});
        }
        if (state is AddAppointmentSuccess) {
          showSuccessToast(
              context: context, message: 'Appointment added successfully');
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Add Appointment'),
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
          child: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is GetMyRoomsLoad) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if (state is GetMyRoomsSuccess && BookingCubit.get(context).rooms.isEmpty) {
                return const Center(
                  child: Text('No Rooms Available for booking'),
                );
              }
              else {
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: SizedBox(
                      width: 120.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) => Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: MyColors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.r))),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  child: DropdownButton<dynamic>(
                                    isExpanded: true,
                                    underline: Container(),
                                    value: chooseRoom,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        chooseRoom = newValue;
                                      });
                                    },
                                    items: BookingCubit.get(context).rooms.isEmpty
                                        ? []
                                        : getAvailableRooms(BookingCubit.get(context).rooms),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) => Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * .7,
                                  child: TeacherSearchField(
                                    searchAction: () {
                                      BookingCubit.get(context).searchTeacher(
                                          searchController.text, context);
                                    },
                                    onFieldSubmitted: (value) {
                                      BookingCubit.get(context).searchTeacher(
                                          searchController.text, context);
                                    },
                                    controller: searchController,
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                      onPressed: () async {
                                        final teacherData =
                                            await Navigator.pushNamed(context,
                                                Routes.registerTeacher);
                                        if (teacherData is ReturnedData) {
                                          teacherNameController.text =
                                              teacherData.name;
                                          teacherIdController.text =
                                              teacherData.id;
                                          setState(() {});
                                        }
                                      },
                                      child: const Text(
                                        'Register a teacher',
                                        style:
                                            TextStyle(color: MyColors.primary),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      )),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * .47,
                                  child: BookingTextField(
                                    isEnabled: false,
                                    hint: 'Teacher name',
                                    myController: teacherNameController,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'teacher name can not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSave: (String? value) {},
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * .47,
                                  child: BookingTextField(
                                    isEnabled: false,
                                    hint: 'Teacher id',
                                    myController: teacherIdController,
                                    onSave: (value) {
                                      teacherId = BookingCubit.get(context)
                                          .searchedTeacher[0]
                                          .id;
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'teacher name can not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * .47,
                                  child: BookingTextField(
                                    isEnabled: true,
                                    hint: 'appointment recursion',
                                    myController:
                                        appointmentRecursionController,
                                    onSave: (value) {
                                      recurrence = value!;
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'teacher name can not be empty';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'enter a valid number';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * .47,
                                  child: BookingTextField(
                                    isEnabled: true,
                                    hint: 'Subject',
                                    myController:
                                    subjectController,
                                    onSave: (value) {
                                      subject = value!;
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'enter the subject';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * .47,
                                  child: BookingTextField(
                                    isEnabled: true,
                                    hint: 'Price',
                                    myController:
                                    priceController,
                                    onSave: (value) {
                                      price = value!;
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'enter the price';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth*.47,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: MyColors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.r))),
                                    child: Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                      child: DropdownButton<dynamic>(
                                        isExpanded: true,
                                        underline: Container(),
                                        value: payMethod,
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            payMethod = newValue.toString();
                                          });
                                        },
                                        items: getFeeMethods(feeMethods),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * .3,
                                  child: TextFormField(
                                    decoration:
                                        const InputDecoration(hintText: 'date'),
                                    minLines: 1,
                                    style: TextStyle(fontSize: 16.sp),
                                    controller: dateController,
                                    onSaved: (value) {},
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-02-12'),
                                      ).then((value) {
                                        if (value == null) {
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(DateTime.now());
                                          date = DateFormat.yMMMd()
                                              .format(DateTime.now());
                                        } else {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                          date =
                                              DateFormat.yMMMd().format(value);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * .3,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'start time'),
                                    style: TextStyle(fontSize: 16.sp),
                                    controller: startTimeController,
                                    onSaved: (value) {},
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        if (value == null) {
                                          startTimeController.text =
                                              TimeOfDay.now().format(context);
                                          startTime = TimeOfDay.now();
                                        } else {
                                          startTimeController.text =
                                              value.format(context);
                                          startTime = value;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * .3,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'end time'),
                                    style: TextStyle(fontSize: 16.sp),
                                    controller: endTimeController,
                                    onSaved: (value) {},
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        if (value == null) {
                                          endTimeController.text =
                                              TimeOfDay.now().format(context);
                                          endTime = TimeOfDay.now();
                                        } else {
                                          endTimeController.text =
                                              value.format(context);
                                          endTime = value;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          BlocBuilder<BookingCubit, BookingState>(
                            builder: (context, state) {
                              if (state is AddAppointmentLoad) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return CustomButton(
                                    text: 'Save',
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        duration =
                                            (startTime.hour - endTime.hour)
                                                .toString();
                                        await BookingCubit.get(context)
                                            .addAppointment(
                                                NewBooking(
                                                    chooseRoom.id,
                                                    teacherId,
                                                    price,
                                                    payMethod,
                                                    date,
                                                    startTime.format(context),
                                                    subject,
                                                    recurrence,
                                                    duration),
                                                context);
                                        widget.centerHomeCubit
                                            .getAppointments(context);
                                      }
                                    });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getAvailableRooms(List<dynamic> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item.name),
            ))
        .toList();
    return menuItems;
  }

  List<DropdownMenuItem> getFeeMethods(List<String> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
      value: (list.indexOf(item)+1).toString(),
      child: Text(item),
    ))
        .toList();
    return menuItems;
  }

  List<String> feeMethods = [
    'per student',
    'per hour',
  ];
}
