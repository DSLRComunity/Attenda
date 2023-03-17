import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../classes/view/widgets/custom_button.dart';
import '../../../classes/view/widgets/custom_text_field.dart';
import '../../../classes/view/widgets/toast.dart';
import '../../business_logic/add_student_cubit/add_student_cubit.dart';
import '../../business_logic/students_cubit/students_cubit.dart';
import '../../models/students_model.dart';
import '../widgets/show_student_dialog.dart';

class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({Key? key}) : super(key: key);

  @override
  State<NewStudentScreen> createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController parentNameController=TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();

  List<DropdownMenuItem> menuItems = [];

  late String name;
  late String parentName;
  late String phone;
  late String parentPhone;
  late String id;
  late String className;
  late String gender;

  @override
  void initState() {
    if(ClassesCubit.get(context).classes!.isNotEmpty){
      menuItems = getMenuItems(context);
      className = menuItems[0].value;
      gender=genders[0];
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    parentNameController.dispose();
    phoneController.dispose();
    parentPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.black,
        title: Text('Add New Student',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyColors.primary)),
        centerTitle: true,
      ),
      body: BlocConsumer<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentError) {
            showErrorToast(context: context, message: state.error);
          }
          if (state is AddStudentSuccess) {
            showStudentDialog(context, id,name,className);

            nameController.clear();
            parentNameController.clear();
            phoneController.clear();
            parentPhoneController.clear();
          }
        },
        builder: (context, state) {
          if(ClassesCubit.get(context).classes!.isEmpty){
            return const Center(child:Text('No Classes Found, Please add a new class'));
          }else{
            return SingleChildScrollView(
              child:ClassesCubit.get(context).classes!.isEmpty?
              Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: const [
                Text('Please Add a Class First !',)
              ],):
              Column(
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
                                      return validateMobile(value);
                                    }),
                              ),
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return Container(
                                    height: 50.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: MyColors.grey),
                                        borderRadius: BorderRadius.all(Radius.circular(10.r))
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                      child: DropdownButton<dynamic>(
                                        isExpanded: true,
                                        underline: Container(),
                                        menuMaxHeight: double.maxFinite,
                                        value: gender,
                                        onChanged: (Object? newValue) {
                                          setState(() {
                                            gender = newValue.toString();
                                          });
                                        },
                                        items: getGenderItems(),
                                      ),
                                    ),
                                  );
                                },
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
                                width: 80.w,
                                child: CustomTextFiled(
                                    hint: 'Enter parent name',
                                    label: 'parent name',
                                    controller: parentNameController,
                                    prefixIcon: Icons.person,
                                    inputType: TextInputType.name,
                                    onSave: (value) {
                                      parentName = value!;
                                    },
                                    validate: (value) {
                                      return validation(value, 'parent name');
                                    }),
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
                                      return validateMobile(value);
                                    }),
                              ),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: MyColors.grey),
                                        borderRadius: BorderRadius.all(Radius.circular(10.r))
                                    ),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                                          child: DropdownButton<dynamic>(
                                            isExpanded: true,
                                            underline: Container(),
                                            menuMaxHeight: double.maxFinite,
                                            value: className,
                                            onChanged: (Object? newValue) {
                                              setState(() {
                                                className = newValue.toString();
                                              });
                                            },
                                            items: getMenuItems(context),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
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
                                  parentName: parentName,
                                  className: className,
                                  parentPhone: parentPhone,
                                  id: _getStudentId(gender),
                                  gender: gender,
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
          }
        },
      ),
    );
  }

  List<DropdownMenuItem> getMenuItems(BuildContext context) {
    List<DropdownMenuItem> menuItems = ClassesCubit.get(context)
        .getClassesNames()
        .map((className) => DropdownMenuItem(
              value: className,
              child: Text(className),
            ))
        .toList();
    return menuItems;
  }

  List<String>genders=['Male','Female'];
  List<DropdownMenuItem> getGenderItems() {
    List<DropdownMenuItem> genderItems = genders
        .map((gender) => DropdownMenuItem(
      value: gender,
      child: Text(gender),
    ))
        .toList();
    return genderItems;
  }

  String _getStudentId(String gender) {
String date=DateFormat('MM-dd').format(DateTime.now());
String randomId=const Uuid().v1();
String first=randomId.substring(0,4);
String last=randomId.substring(4,8);
String genderId=gender[0].toLowerCase();

    id = 'st$genderId$first$date$last';
    return id;

    //st-genderId-first4num-12-05-last3num
  }
  String? validation(String? value, String text) {
    if (value!.isEmpty) {
      return 'Enter the $text';
    } else {
      return null;
    }
  }
  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value) ||
        value.length < 11 ||
        value.length > 11) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
  String? validateNationalId(String? value) {
    if (value!.isEmpty || value.length != 7) {
      return 'please enter last 7 digits in national id';
    }
    return null;
  }
}
