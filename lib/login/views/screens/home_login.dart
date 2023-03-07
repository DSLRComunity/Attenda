import 'package:attenda/core/colors.dart';
import 'package:attenda/login/business_logic/home_login_cubit/home_login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLogin extends StatelessWidget {
  HomeLogin({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
              color: MyColors.primary,
              // child: Center(
              //   child: Image.asset('images/logo.jfif',height: MediaQuery.of(context).size.height*.25),
              // ),
            ),
          ),
      Expanded(
        flex: 3,
        child: BlocBuilder<HomeLoginCubit,HomeLoginState>(
          builder: (context, state) {
            return HomeLoginCubit.get(context).view;
          },
        ),
      ),
        ],
      ),
    );
  }
}
