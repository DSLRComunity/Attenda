import 'package:attenda/center/new_room/business_logic/add_room_cubit.dart';
import 'package:attenda/center/new_room/models/new_room_model.dart';
import 'package:attenda/center/rooms/business_logic/rooms_cubit.dart';
import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../classes/view/widgets/custom_text_field.dart';
import '../../../classes/view/widgets/toast.dart';
import '../../../login/views/widgets/custom_button.dart';

class RoomDialog extends StatefulWidget {
  const RoomDialog({Key? key}) : super(key: key);

  @override
  State<RoomDialog> createState() => _RoomDialogState();
}

class _RoomDialogState extends State<RoomDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final roomNumController = TextEditingController();
  final maxSizeController = TextEditingController();

  late String roomNum;
  late String maxSize;
  late int color;

  @override
  void initState() {
    color = Colors.teal.value;
    roomNum = '';
    maxSize = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddRoomCubit, AddRoomState>(
      listener: (context, state) async {
        if (state is AddRoomSuccess) {
          showSuccessToast(
              context: context, message: 'Room Added Successfully');
          roomNumController.clear();
          maxSizeController.clear();
          await RoomsCubit.get(context).getRooms(context);
        }
        if (state is AddRoomError) {
          showErrorToast(context: context, message: state.error);
        }
      },
      child: AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                width: 120.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Room '),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFiled(
                        hint: 'room name',
                        label: 'Room Name',
                        prefixIcon: Icons.numbers,
                        controller: roomNumController,
                        onSave: (value) {
                          roomNum = value!;
                        },
                        onSubmit: (value) async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await AddRoomCubit.get(context).addRoom(
                                NewRoomModel(
                                  name: roomNum,
                                  color: int.tryParse(color.toString().substring(0,6))!,
                                  size: maxSize,
                                ),
                                context);

                            // ClassesCubit.get(context).getAllClasses();
                          }
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the room number !';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFiled(
                        hint: 'max size',
                        label: 'Max Size',
                        prefixIcon: Icons.groups,
                        controller: maxSizeController,
                        onSave: (value) {
                          maxSize = value!;
                        },
                        onSubmit: (value) async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await AddRoomCubit.get(context).addRoom(
                                NewRoomModel(
                                  name: roomNum,
                                  color: int.tryParse(color.toString().substring(0,6))!,
                                  size: maxSize,
                                ),
                                context);
                          }
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the max size of the room !';
                          } else if (value is num) {
                            return 'valid number';
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20.h,
                          width: 20.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(color),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        CustomLoginButton(
                            text: 'Pick Color',
                            onPressed: () => pickColor(context)),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    BlocBuilder<AddRoomCubit, AddRoomState>(
                      builder: (context, state) {
                        if (state is AddRoomLoad) {
                          return const CircularProgressIndicator();
                        } else {
                          return CustomButton(
                              text: 'Add',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  await AddRoomCubit.get(context).addRoom(
                                      NewRoomModel(
                                        name: roomNum,
                                        color: int.tryParse(color.toString().substring(0,6))!,
                                        size: maxSize,
                                      ),
                                      context);
                                }
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColorPicker() => BlockPicker(
        pickerColor: Color(color),
        availableColors: const [
          Colors.black,
          Colors.amber,
          Colors.deepPurpleAccent,
          Colors.blueAccent,
          Colors.grey,
          Colors.pinkAccent,
          Colors.lightBlueAccent,
          Colors.red,
          Colors.yellow,
          Colors.greenAccent,
          Colors.blue,
          Colors.brown,
          Colors.purple,
          Colors.teal,
        ],
        onColorChanged: (Color color) => setState(() {
          this.color = color.value;
          Navigator.of(context).pop();
        }),
      );

  void pickColor(BuildContext context) => showDialog(context: context, builder: (context) => AlertDialog(
            title: const Text('Pick room color'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildColorPicker(),
              ],
            ),
          ));
}
