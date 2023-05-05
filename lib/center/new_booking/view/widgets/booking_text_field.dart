import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/colors.dart';

class BookingTextField extends StatelessWidget {
  const BookingTextField(
      {Key? key,
      required this.hint,
      required this.myController,
      required this.validate,
      required this.onSave,
      required this.isEnabled})
      : super(key: key);

  final String? hint;
  final TextEditingController myController;
  final String? Function(String? value) validate;
  final void Function(String?)? onSave;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.black),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.black),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.black),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        hintText: hint ?? '',
        hintStyle: Theme.of(context).textTheme.displaySmall,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      onSaved: onSave,
      controller: myController,
      validator: validate,
      enabled: isEnabled,
    );
  }
}
