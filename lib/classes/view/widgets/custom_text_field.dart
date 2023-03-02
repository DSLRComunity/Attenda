import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled(
      {Key? key,
      this.inputType = TextInputType.text,
      this.isPass = false,
      required this.hint,
      required this.label,
      required this.prefixIcon,
      required this.onSave,
      required this.validate,
      this.onTab,
      this.controller})
      : super(key: key);
  final TextInputType inputType;
  final bool isPass;
  final String hint;
  final String label;
  final IconData prefixIcon;
  final void Function(String? value) onSave;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final void Function()? onTab;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPass,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          // enabledBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: MyColors.white),
          // ),
          // disabledBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: MyColors.white),
          // ),
          // focusedBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: MyColors.white),
          // ),
          hintText: hint,
          labelText: label,
          prefixIcon: Icon(
            prefixIcon,
            color: MyColors.primary,
          ),
        ),
        validator: validate,
        onTap: onTab,
        onSaved: onSave,
      ),
    );
  }
}
