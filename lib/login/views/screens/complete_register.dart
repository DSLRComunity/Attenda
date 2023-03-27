import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/cache_helper.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/core/routes.dart';
import 'package:attenda/core/strings.dart';
import 'package:attenda/login/business_logic/login_cubit/login_cubit.dart';
import 'package:attenda/login/views/widgets/custom_button.dart';
import 'package:attenda/login/views/widgets/custom_text_field.dart';
import 'package:attenda/register/views/widgets/data.dart';
import 'package:attenda/whatsapp/business_logic/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteRegisterScreen extends StatefulWidget {
  const CompleteRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CompleteRegisterScreen> createState() => _CompleteRegisterScreenState();
}

class _CompleteRegisterScreenState extends State<CompleteRegisterScreen> {
  final technicalSupportNumberController = TextEditingController();
  final passController=TextEditingController();
  final confirmPassController=TextEditingController();

  late String technicalSupportNumber;
  late String expectedStudentsNum;
  late String password;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  List<DropdownMenuItem> getExpectedStudentsItems(List<String> list) {
    List<DropdownMenuItem> menuItems = list
        .map((item) =>
        DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
        .toList();
    return menuItems;
  }

  @override
  void initState() {
    expectedStudentsNum = expectedStudentsList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocListener<LoginCubit,LoginState>(
        listener: (context, state) {
          if(state is CompleteRegisterError){
            showErrorToast(context: context, message: state.error);
          }else if(state is CompleteRegisterSuccess){
            showSuccessToast(context: context, message: 'Login Successfully');
            uId = FirebaseAuth.instance.currentUser!.uid;
            role='t';
            if (LoginCubit.get(context).rememberMe) {
              CacheHelper.putData(key: 'uId', value: uId);
              CacheHelper.putData(key: 'role', value: role);
            }
            goToHome(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.125,
              vertical: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Column(
              children: [
                const Text('Complete Registration'),
                LayoutBuilder(
                  builder: (context,constraints) =>Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth*.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expected students number',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                  color: Colors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) =>
                                  Container(
                                    width: constraints.maxWidth*.48,
                                      decoration: BoxDecoration(
                                          border:
                                          Border.all(color: MyColors.primary),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.r))),
                                      child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                        child: DropdownButton<dynamic>(
                                          isExpanded: true,
                                          underline: Container(),
                                          value: expectedStudentsNum,
                                          onChanged: (Object? newValue) {
                                            setState(() {
                                              expectedStudentsNum =
                                                  newValue.toString();
                                            });
                                          },
                                          items: getExpectedStudentsItems(
                                              expectedStudentsList),
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Technical support number',
                            style: Theme
                                .of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black, fontSize: 18.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            width: constraints.maxWidth*.48,
                            child: MyTextField(
                              onSave: (value) {
                                technicalSupportNumber = value!;
                              },
                              myController: technicalSupportNumberController,
                              validate: (String? value) {
                                return MyFunctions.validateMobile(value);
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
                SizedBox(height: 15.h,),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.black, fontSize: 18),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: constraints.maxWidth * .48,
                              child: BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) => MyTextField(
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
                                  isPassword:
                                  LoginCubit.get(context).isVisible,
                                  suffixIcon:
                                  LoginCubit.get(context).visibleIcon,
                                  suffixPress: () {
                                    LoginCubit.get(context)
                                        .changePassVisibility();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.black, fontSize: 18),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: constraints.maxWidth * .48,
                              child: BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) => MyTextField(
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 25.h,),
                BlocBuilder<LoginCubit,LoginState>(
                  builder: (context, state) {
                    if(state is CompleteRegisterLoad){
                      return const Center(child: CircularProgressIndicator(),);
                    }else {
                      return  CustomLoginButton(onPressed: () async{
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          await LoginCubit.get(context).completeRegister(expectedStudentsNum, technicalSupportNumber,password);
                        }
                      }, text: 'Finish');
                  }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToHome(BuildContext context) {
    technicalSupportNumberController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    Navigator.pushReplacementNamed(context, Routes.homeRoute);
  }

}
