import 'package:attenda/center/center_register/bsuiness_logic/center_register_cubit.dart';
import 'package:attenda/center/center_register/models/center_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../classes/view/widgets/toast.dart';
import '../../../../core/colors.dart';
import '../../../../login/views/widgets/custom_button.dart';
import '../../../../login/views/widgets/custom_text_field.dart';
import '../../../center_login/business_logic/center_home_login/center_login_cubit.dart';

class CenterRegisterScreen extends StatefulWidget {
  const CenterRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CenterRegisterScreen> createState() => _CenterRegisterScreenState();
}

class _CenterRegisterScreenState extends State<CenterRegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final centerNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roomsNumController = TextEditingController();
  final locationController = TextEditingController();
  final infoController = TextEditingController();

  late String centerName;
  late String email;
  late String location;
  late String phone;
  late int roomsNum;
  late String feeMethod;
  late String info;

  @override
  void initState() {
    feeMethod = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocListener<CenterRegisterCubit, CenterRegisterState>(
        listener: (context, state) {
          if (state is RegisterFirstStepSuccess) {
            CenterHomeLoginCubit.get(context).changeToVerification(
                CenterRegisterCubit.get(context).centerModel!.email);
          } else if (state is RegisterFirstStepError) {
            showErrorToast(context: context, message: 'Error, try again');
          }
        },
        child: ImprovedScrolling(
          scrollController: _scrollController,
          enableKeyboardScrolling: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08,
                vertical: MediaQuery.of(context).size.height * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Center Registration',
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
                              'Center Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.48,
                              child: MyTextField(
                                onSave: (value) {
                                  centerName = value!;
                                },
                                myController: centerNameController,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'enter center name';
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
                              'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * .48,
                              child: MyTextField(
                                onSave: (value) {
                                  email = value!;
                                },
                                myController: emailController,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'enter an email';
                                  } else if (value.endsWith('.com') &&
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
                              'Phone Number',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.48,
                              child: MyTextField(
                                onSave: (value) {
                                  phone = value!;
                                },
                                myController: phoneController,
                                validate: (String? value) {
                                  return validateMobile(value);
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
                              'Location',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.48,
                              child: MyTextField(
                                onSave: (value) {
                                  location = value!;
                                },
                                myController: locationController,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'enter location';
                                  } else {
                                    return null;
                                  }
                                },
                                isPassword: false,
                                type: TextInputType.streetAddress,
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
                              'Info about center',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: constraints.maxWidth * .48,
                              child: TextFormField(
                                maxLines: 5,
                                controller: infoController,
                                onSaved: (value) {
                                  info = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'this field can not be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: MyColors.primary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: MyColors.primary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: MyColors.primary),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rooms Number',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Colors.black, fontSize: 18.sp),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * 0.48,
                                  child: MyTextField(
                                    onSave: (value) {
                                      roomsNum = int.tryParse(value!)!;
                                    },
                                    myController: roomsNumController,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'enter number of rooms';
                                      } else {
                                        return null;
                                      }
                                    },
                                    isPassword: false,
                                    type: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h,),
                            BlocBuilder<CenterRegisterCubit, CenterRegisterState>(
                              builder: (context, state) {
                                if (state is RegisterFirstStepLoad) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return SizedBox(
                                    width: 70.w,
                                    child: CustomLoginButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            CenterRegisterCubit cubit =
                                                CenterRegisterCubit.get(
                                                    context);
                                            cubit.centerModel = CenterModel(
                                              email: email,
                                              phone: phone,
                                              centerName: centerName,
                                              attendaEmail: ' ',
                                              location: location,
                                              roomsNum: roomsNum,
                                              feeMethod: feeMethod,
                                              info: info,
                                            );
                                            await CenterRegisterCubit.get(
                                                    context)
                                                .centerRegister();
                                          }
                                        },
                                        text: 'Next'),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
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
      ),
    );
  }

  void goToLogin(BuildContext context) {
    CenterHomeLoginCubit.get(context).changeToLogin();
    emailController.dispose();
    centerNameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    roomsNumController.dispose();
    _scrollController.dispose();
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

  List<DropdownMenuItem> getFeeMethods(List<String> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) => DropdownMenuItem(
              value: list.indexOf(item).toString(),
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
