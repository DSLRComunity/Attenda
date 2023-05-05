import 'package:attenda/center/new_booking/business_logic/booking_cubit.dart';
import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TeacherSearchField extends StatelessWidget {
  const TeacherSearchField(
      {Key? key, required this.searchAction, required this.controller,this.onFieldSubmitted})
      : super(key: key);
  final void Function()? searchAction;
  final TextEditingController controller;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: TextFormField(
        style: TextStyle(fontSize: 20.sp),
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              borderSide: const BorderSide(color: MyColors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              borderSide: const BorderSide(color: MyColors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              borderSide: const BorderSide(color: MyColors.grey)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              borderSide: const BorderSide(color: MyColors.grey)),
          hintText: 'Search',
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.grey[700]),
          suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state is SearchForTeacherLoad) {
                    return const CircularProgressIndicator();
                  } else {
                    return GestureDetector(
                      onTap: searchAction,
                      child: SvgPicture.asset(
                        "${(kDebugMode && kIsWeb) ? "" : "assets/"}images/search.svg",
                        width: 18.w,
                        height: 18.h,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              )),
        ),
        onFieldSubmitted:onFieldSubmitted,
      ),
    );
  }
}
