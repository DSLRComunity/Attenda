import 'package:attenda/center/new_teacher/business_logic/new_teacher_cubit.dart';
import 'package:attenda/center/new_teacher/view/widgets/register_success_dialog.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/login/views/widgets/custom_button.dart';
import 'package:attenda/login/views/widgets/custom_text_field.dart';
import 'package:attenda/whatsapp/business_logic/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../register/views/widgets/data.dart';

class NewTeacherScreen extends StatefulWidget {
  const NewTeacherScreen({Key? key}) : super(key: key);

  @override
  State<NewTeacherScreen> createState() => _NewTeacherScreenState();
}

class _NewTeacherScreenState extends State<NewTeacherScreen> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final latNameController = TextEditingController();
  final personalPhoneNumberController = TextEditingController();
  final subjectController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late String phone;
  late String firstName;
  late String lastName;
  late Map<String, dynamic> governorate;
  late String governorateName;
  late String governorateCode;
  late String subject;

  int _value = 1;

  @override
  void initState() {
    firstName='';
    lastName='';
    password = '12345678';
    phone='';
    governorate = governorates[0];
    governorateName = governorates[0]['governorate'];
    governorateCode = governorates[0]['code'];
    subject = arabicSubjects[0];
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    personalPhoneNumberController.dispose();
    latNameController.dispose();
    subjectController.dispose();
    super.dispose();
  }
  void clearData(){
    emailController.clear();
    firstNameController.clear();
    personalPhoneNumberController.clear();
    latNameController.clear();
    subjectController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewTeacherCubit, NewTeacherState>(
      listener: (context, state) {
        if (state is RegisterTeacherSuccess) {
          String id=NewTeacherCubit.get(context)
              .createTeacherId(phone, governorateCode);
          clearData();
          showDialog(context: context, builder: (context) => TeacherDialogBody(
                name: firstName,
                email: email,
                id:id,
                password: password),);
        }
        if (state is RegisterTeacherError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: MyColors.black,
            duration: const Duration(seconds: 2),
            dismissDirection: DismissDirection.down,
            elevation: 2,
            margin: const EdgeInsets.all(10),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 3,
            backgroundColor: MyColors.black,
            title: const Text('Register a new teacher') ,
            leading: IconButton(icon:  const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(ReturnedData(firstName, phone==''?'':NewTeacherCubit.get(context).createTeacherId(phone, governorateCode)));
            },) ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth*.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.black, fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              MyTextField(
                                onSave: (value) {
                                  firstName = value!;
                                },
                                myController: firstNameController,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'enter first name';
                                  } else {
                                    return null;
                                  }
                                },
                                isPassword: false,
                                type: TextInputType.name,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.black, fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              MyTextField(
                                onSave: (value) {
                                  lastName = value!;
                                },
                                myController: latNameController,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'enter last name';
                                  } else {
                                    return null;
                                  }
                                },
                                isPassword: false,
                                type: TextInputType.name,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Governorate',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.black, fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              StatefulBuilder(
                                builder: (context, setState) => Container(
                                    width: constraints.maxWidth * .25,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: MyColors.primary),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.r))),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: DropdownButton<dynamic>(
                                        isExpanded: true,
                                        underline: Container(),
                                        value: governorate,
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            governorate = newValue;
                                            governorateName =
                                                newValue['governorate'];
                                            governorateCode = newValue['code'];
                                          });
                                        },
                                        items: getGovernoratesItems(governorates),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  LayoutBuilder(
                    builder: (context, constraints) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * .25,
                              child: MyTextField(
                                onSave: (value) {
                                  email = value!;
                                },
                                myController: emailController,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'enter an email';
                                  } else if ((value.endsWith('.com') ||
                                          value.endsWith('.org')) &&
                                      value.contains('@') &&
                                      value
                                          .substring(0, value.indexOf('@'))
                                          .isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'enter a valid email';
                                  }
                                },
                                type: TextInputType.emailAddress,
                                isPassword: false,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal phone number',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                              child: MyTextField(
                                onSave: (value) {
                                  phone = value!;
                                },
                                myController: personalPhoneNumberController,
                                validate: (String? value) {
                                  return MyFunctions.validateMobile(value);
                                },
                                isPassword: false,
                                type: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subjects',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) => Container(
                                  width: constraints.maxWidth * .25,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: MyColors.primary),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r))),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: DropdownButton<dynamic>(
                                      isExpanded: true,
                                      underline: Container(),
                                      value: subject,
                                      onChanged: (Object? newValue) {
                                        setState(() {
                                          subject = newValue.toString();
                                        });
                                      },
                                      items: getSubjectsItem(_value == 1
                                          ? arabicSubjects
                                          : _value == 2
                                              ? englishSubjects
                                              : frenchSubjects),
                                    ),
                                  )),
                            ),
                            LayoutBuilder(
                                builder: (context, constraints) => Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text('بالفرنسية'),
                                            Radio(
                                                value: 3,
                                                groupValue: _value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value!;
                                                    subject = frenchSubjects[0];
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('بالانجليزية'),
                                            Radio(
                                                value: 2,
                                                groupValue: _value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value!;
                                                    subject = englishSubjects[0];
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('بالعربية'),
                                            Radio(
                                                value: 1,
                                                groupValue: _value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value!;
                                                    subject = arabicSubjects[0];
                                                  });
                                                })
                                          ],
                                        ),
                                      ],
                                    )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BlocBuilder<NewTeacherCubit, NewTeacherState>(
                    buildWhen: (previous, current) =>
                        (current is RegisterTeacherLoad ||
                            current is RegisterTeacherSuccess ||
                            current is RegisterTeacherError),
                    builder: (context, state) {
                      if (state is RegisterTeacherLoad) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return CustomLoginButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await NewTeacherCubit.get(context).registerTeacher(
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: email,
                                  password: password,
                                  phone: phone,
                                  expectedStudentsNum: '',
                                  governorate: governorateName,
                                  technicalSupportNum: '',
                                  governorateCode: governorateCode,
                                  subject: subject,
                                );
                              }
                            },
                            text: 'Sign up');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getGovernoratesItems(List<Map<String, dynamic>> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item['governorate']),
            ))
        .toList();
    return menuItems;
  }

  List<DropdownMenuItem> getSubjectsItem(List<String> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList();
    return menuItems;
  }
}

class ReturnedData {
  String name;
  String id;
  ReturnedData(this.name,this.id);
}
