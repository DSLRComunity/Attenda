import 'package:attenda/center/center_login/business_logic/center_home_login/center_login_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/colors.dart';

class CenterHomeLogin extends StatelessWidget {
  const CenterHomeLogin({Key? key}) : super(key: key);

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
              child: Center(
                child: Image.asset(
                    "${(kDebugMode && kIsWeb)
                        ? ""
                        : "assets/"}images/logo.jfif",
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .25),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: BlocBuilder<CenterHomeLoginCubit, CenterHomeLoginState>(
              builder: (context, state) {
                return CenterHomeLoginCubit
                    .get(context)
                    .view;
              },
            ),
          ),
        ],
      ),
    );
  }
}
