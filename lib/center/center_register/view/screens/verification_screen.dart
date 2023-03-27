import 'dart:async';
import 'package:attenda/center/center_login/business_logic/center_home_login/center_login_cubit.dart';
import 'package:attenda/center/center_register/bsuiness_logic/center_register_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer? timer;

  void sendVerification() async {
    await CenterRegisterCubit.get(context).sendEmailVerification();
  }

  void checkEmailVerified() async {
    await CenterRegisterCubit.get(context).checkEmailVerified();
  }

  @override
  void initState() {
    CenterRegisterCubit.get(context).isEmailVerified =
        FirebaseAuth.instance.currentUser!.emailVerified;
    if (!CenterRegisterCubit.get(context).isEmailVerified) {
      sendVerification();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CenterRegisterCubit, CenterRegisterState>(
      listener: (context, state) async {
        if (state is VerifiedSuccess) {
          String attendaEmail = generateAttendaEmail(widget.email);
          await CenterRegisterCubit.get(context).updateEmail(attendaEmail);
          CenterHomeLoginCubit.get(context).changeToSetPassword(attendaEmail);
        }
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'We have sent a verification request to your email ${widget.email}, please verify to continue',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 10.h,
            ),
            TextButton(
                onPressed: () {
                  CenterHomeLoginCubit.get(context).changeToRegister();
                },
                child: Text('Back'))
          ],
        ),
      ),
    );
  }

  String generateAttendaEmail(String email) {
    String attendaEmail = email.substring(0, email.indexOf('@'));
    attendaEmail = '$attendaEmail@attenda.org';
    return attendaEmail;
  }
}
