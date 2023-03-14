import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/routes.dart';
import 'package:attenda/login/business_logic/home_login_cubit/home_login_cubit.dart';
import 'package:attenda/login/business_logic/login_cubit/login_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/cache_helper.dart';
import '../../../core/strings.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocListener<LoginCubit,LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            showErrorToast(context: context, message: state.error);
          } else if (state is LoginSuccess) {
            showSuccessToast(
                context: context, message: 'Login Successfully');
            uId = state.uId;
            if (LoginCubit.get(context).rememberMe) {
              CacheHelper.putData(key: 'uId', value: uId);
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Attenda',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Login',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Email',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: 5.h,
                ),
                MyTextField(
                  onSave: (value) {
                    email = value!;
                  },
                  myController: emailController,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'please enter email';
                    } else {
                      return null;
                    }
                  },
                  hint: 'Enter email address',
                  isPassword: false,
                  type: TextInputType.emailAddress,
                  onSubmit: (value)async{
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await LoginCubit.get(context).loginUser(
                          email: email, password: password);
                    }
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  'Password',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: 5.h,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) => MyTextField(
                    onSave: (value) {
                      password = value!;
                    },
                    myController: passController,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'please enter password';
                      } else {
                        return null;
                      }
                    },
                    type: TextInputType.visiblePassword,
                    isPassword: LoginCubit.get(context).isVisible,
                    suffixIcon: LoginCubit.get(context).visibleIcon,
                    suffixPress: () {
                      LoginCubit.get(context).changePassVisibility();
                    },
                    hint: 'Enter your password',
                    onSubmit: (value)async{
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await LoginCubit.get(context).loginUser(
                            email: email, password: password);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: CustomLoginButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await LoginCubit.get(context).loginUser(
                                    email: email, password: password);
                              }
                            },
                            text: 'Login'),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Remember Me',style: Theme.of(context).textTheme.bodySmall,),
                      SizedBox(width: 5.w,),
                      Checkbox(
                        value: LoginCubit.get(context).rememberMe,
                        onChanged: (value) => LoginCubit.get(context).changeRememberMe(value),

                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'OR',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MyIconButton(
                        icon:
                            "${(kDebugMode && kIsWeb) ? "" : "assets/"}images/Google.svg",
                        title: 'Google'),
                    SizedBox(
                      width: 10.w,
                    ),
                    const MyIconButton(
                        icon:
                            "${(kDebugMode && kIsWeb) ? "" : "assets/"}images/Facebook.svg",
                        title: 'Facebook'),
                  ],
                ),
                SizedBox(height: 50.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have account?',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          HomeLoginCubit.get(context).changeToRegister();
                        },
                        child: const Text('Sign up'))
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToHome(BuildContext context) {
    emailController.dispose();
    passController.dispose();
    Navigator.pushReplacementNamed(context, Routes.homeRoute);
  }
}
