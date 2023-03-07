import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/login/business_logic/home_login_cubit/home_login_cubit.dart';
import 'package:attenda/register/business_logic/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../login/views/widgets/custom_button.dart';
import '../../../login/views/widgets/custom_text_field.dart';
import '../widgets/data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final firstNameController = TextEditingController();
  final latNameController = TextEditingController();
  final confirmPassController = TextEditingController();
  final personalPhoneNumberController = TextEditingController();
  final technicalSupportNumberController = TextEditingController();
  final subjectController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late String phone;
  late String firstName;
  late String lastName;
  late String technicalSupportNumber;
  late Map<String,dynamic> governorate;
  late String governorateName;
  late String governorateCode;
  late String expectedStudentsNum;

  //late String subject;

  List<DropdownMenuItem> getGovernoratesItems(List<Map<String, dynamic>> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item['governorate']),
            ))
        .toList();
    return menuItems;
  }
  List<DropdownMenuItem> getExpectedStudentsItems(List<String> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList();
    return menuItems;
  }

  @override
  void initState() {
    governorate=governorates[0];
    expectedStudentsNum = expectedStudentsList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.04,
        ),
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              showSuccessToast(context: context, message: 'Registered Success');
            } else if (state is RegisterError) {
              showErrorToast(context: context, message: state.error);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 30.h,
                ),
                LayoutBuilder(
                  builder: (context, constraints) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: MyTextField(
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
                          ),
                        ],
                      ),
                      Column(
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
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: MyTextField(
                              onSave: (value) {
                                lastName = value!;
                              },
                              myController: latNameController,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'ente last name';
                                } else {
                                  return null;
                                }
                              },
                              isPassword: false,
                              type: TextInputType.name,
                            ),
                          ),
                        ],
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
                            'personal phone number',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black, fontSize: 18.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: MyTextField(
                              onSave: (value) {
                                phone = value!;
                              },
                              myController: personalPhoneNumberController,
                              validate: (String? value) {
                                validateMobile(value);
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
                            'Technical support number',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black, fontSize: 18.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: MyTextField(
                              onSave: (value) {
                                technicalSupportNumber = value!;
                              },
                              myController: technicalSupportNumberController,
                              validate: (String? value) {
                                validateMobile(value);
                              },
                              isPassword: false,
                              type: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                LayoutBuilder(
                  builder: (context, constraints) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * .45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'governorate',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) => SizedBox(
                                  width: constraints.maxWidth * .45,
                                  child: DropdownButton<dynamic>(
                                    value: governorate,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        governorate=newValue;
                                        governorateName = newValue['governorate'];
                                        governorateCode=newValue['code'];
                                      });
                                    },
                                    items: getGovernoratesItems(governorates),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth * .45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Technical support number',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) => SizedBox(
                                  width: constraints.maxWidth * .45,
                                  child: DropdownButton<dynamic>(
                                    value: expectedStudentsNum,
                                    onChanged: (Object? newValue) {
                                      setState(() {
                                        expectedStudentsNum =
                                            newValue.toString();
                                      });
                                    },
                                    items: getExpectedStudentsItems(expectedStudentsList),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'Email',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.black, fontSize: 18.sp),
                ),
                SizedBox(height: 5.h),
                MyTextField(
                  onSave: (value) {
                    email = value!;
                  },
                  myController: emailController,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'enter an email';
                    } else if (value.endsWith('.com') &&
                        value.contains('@') &&
                        value.substring(0, value.indexOf('@')).isNotEmpty) {
                      return null;
                    } else {
                      return 'enter a valid email';
                    }
                  },
                  type: TextInputType.emailAddress,
                ),
                SizedBox(height: 15.h),
                Text(
                  'Password',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.black, fontSize: 18),
                ),
                SizedBox(height: 5.h),
                MyTextField(
                  onSave: (value) {
                    password = value!;
                  },
                  myController: passController,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'enter a password';
                    } else if (value.length < 8) {
                      return 'password must be above 8 digits';
                    } else {
                      return null;
                    }
                  },
                  type: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                SizedBox(height: 15.h),
                Text(
                  'Confirm Password',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.black, fontSize: 18),
                ),
                SizedBox(height: 5.h),
                MyTextField(
                  myController: confirmPassController,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'please confirm the password';
                    } else if (value.length < 8) {
                      return 'password must be above 8 digits';
                    } else if (passController.text !=
                        confirmPassController.text) {
                      return 'password is wrong';
                    } else {
                      return null;
                    }
                  },
                  type: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterLoad) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return CustomLoginButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              await RegisterCubit.get(context).register(
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: email,
                                  password: password,
                                  phone: phone,
                                  expectedStudentsNum: expectedStudentsNum,
                                  governorate: governorateName,
                                  technicalSupportNum: technicalSupportNumber,
                              governorateCode: governorateCode);
                              goToLogin(context);
                            }
                          },
                          text: 'Sign up');
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          goToLogin(context);
                        },
                        child: const Text('Sign in'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
  void goToLogin(BuildContext context) {
    HomeLoginCubit.get(context).changeToLogin();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    firstNameController.dispose();
    latNameController.dispose();
    personalPhoneNumberController.dispose();
    technicalSupportNumberController.dispose();
    subjectController.dispose();
  }
}
