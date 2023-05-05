import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/colors.dart';
import '../../../core/routing/routes.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 50.h,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.centerLoginRoute);
                    },
                    style: ButtonStyle(
                      animationDuration: const Duration(seconds: 2),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: const BorderSide(color: MyColors.black, width: 2))),backgroundColor: MaterialStateProperty.all(Colors.white)),
                    child:  Text(
                      'Login as a center',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.black),
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 50.h,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.homeLoginRoute);
                    },
                    style: ButtonStyle(
                        animationDuration: const Duration(seconds: 2),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: const BorderSide(color: MyColors.black, width: 2))),backgroundColor: MaterialStateProperty.all(Colors.white)),
                    child:  Text(
                      'Login as a teacher',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
