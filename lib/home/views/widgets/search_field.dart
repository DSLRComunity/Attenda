import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      child: SizedBox(
        height: 20.h,
        width: 50.w,
        child: TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: MyColors.white,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: MyColors.grey)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: MyColors.grey)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: MyColors.grey)),
            disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: MyColors.grey)),
            prefixIconConstraints: const BoxConstraints(minWidth: 5 ),
            prefixIcon: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 5.w),
                child: SvgPicture.asset(
                  'images/search.svg',
                  width: 18.w,
                  height: 18.h,
                )),
            hintText: 'Search',
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}
