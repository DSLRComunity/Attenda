import 'package:attenda/center/center_login/business_logic/center_home_login/center_login_cubit.dart';
import 'package:attenda/center/center_register/bsuiness_logic/center_register_cubit.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/login/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../login/views/widgets/custom_text_field.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({Key? key, required this.attendaEmail})
      : super(key: key);
  final String attendaEmail;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String password;
  late String confirmPassword;

  void _goToLogin() {
    passController.dispose();
    confirmPassController.dispose();
    CenterHomeLoginCubit.get(context).changeToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CenterRegisterCubit,CenterRegisterState>(
      listener: (context, state) {
        if (state is CreateCenterSuccess) {
          showSuccessToast(context: context, message: 'Register Success');
          _goToLogin();
        }
        if (state is CreateCenterError) {
          showErrorToast(context: context, message: 'Error, try again');
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                  text:
                      'Email Verified Successfully, here is your attenda email ',
                ),
                TextSpan(
                  text: widget.attendaEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ])),
              SizedBox(
                height: 20.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    width: constraints.maxWidth * .7,
                    child: MyTextField(
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
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    width: constraints.maxWidth * .7,
                    child: MyTextField(
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
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              BlocBuilder<CenterRegisterCubit, CenterRegisterState>(
                builder: (context, state) {
                  if (state is CreateCenterLoad) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CustomLoginButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await CenterRegisterCubit.get(context).setPassword(password);
                            CenterRegisterCubit.get(context).centerModel!.attendaEmail = widget.attendaEmail;
                            await CenterRegisterCubit.get(context).createCenterCollection();
                          }
                        },
                        text: 'Confirm');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
