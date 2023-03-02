import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import '../../../classes/view/widgets/custom_button.dart';
import '../../../classes/view/widgets/custom_text_field.dart';
import '../../../classes/view/widgets/toast.dart';
import '../../business_logic/add_student_cubit/add_student_cubit.dart';
import '../../business_logic/students_cubit/students_cubit.dart';
import '../../models/students_model.dart';
import '../widgets/drop_down.dart';
import '../widgets/show_student_dialog.dart';

class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({Key? key}) : super(key: key);

  @override
  State<NewStudentScreen> createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();

  late String name;
  late String phone;
  late String parentPhone;
  late String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        title:  Text('Add New Student',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.primary)),
        centerTitle: true,
      ),
      body: BlocConsumer<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentError) {
            showErrorToast(context: context, message: state.error);
          }
          if (state is AddStudentSuccess) {
            showStudentDialog(context, id);
            nameController.clear();
            phoneController.clear();
            parentPhoneController.clear();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
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
                                  validate: (value) {
                                    return validation(value, 'name');
                                  }),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 80.w,
                              child: CustomTextFiled(
                                  hint: 'Phone Number',
                                  label: 'Phone',
                                  controller: phoneController,
                                  prefixIcon: Icons.phone,
                                  inputType: TextInputType.phone,
                                  onSave: (value) {
                                    phone = value!;
                                  },
                                  validate: (value) {
                                    return validation(value, 'phone number');
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
                            SizedBox(
                             height: 60,
                              child: MyDropDown(
                                menuItems:getMenuItems(context),   //  getMenuItems(context),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 80.w,
                              child: CustomTextFiled(
                                  hint: 'parent phone',
                                  label: 'parent phone',
                                  inputType: TextInputType.phone,
                                  prefixIcon: Icons.phone,
                                  controller: parentPhoneController,
                                  onSave: (value) {
                                    parentPhone = value!;
                                  },
                                  validate: (value) {
                                    return validation(value, 'parent phone');
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
                        text: 'Add',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await AddStudentCubit.get(context).addStudent(StudentsModel(
                              name: name,
                              phone: phone,
                              className: 'Wednesday, 2:15 PM',
                              parentPhone: parentPhone,
                              id: _getStudentId(),
                            ),context);
                            await StudentsCubit.get(context).getAllStudents();
                          }
                        })),
                Divider(
                  thickness: 2.h,
                  color: Colors.grey,
                  endIndent: 3.w,
                  indent: 3.w,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem> getMenuItems(BuildContext context) {
    List<DropdownMenuItem> menuItems = ClassesCubit.get(context)
        .classesNames()
        .map((className) => DropdownMenuItem(
              value: className,
              child: Text(className),
            ))
        .toList();
    return menuItems;
  }

  String _getStudentId() {
    id = const Uuid().v1();
    return id;
  }

  String? validation(String? value, String text) {
    if (value!.isEmpty) {
      return 'Enter the $text';
    } else {
      return null;
    }
  }
}
