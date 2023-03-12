import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({Key? key,
    this.inputType = TextInputType.text,
    this.isPass = false,
    required this.hint,
    required this.label,
    required this.prefixIcon,
    required this.onSave,
    required this.validate,
    this.onTab,
    this.controller,
    this.suffix,

  })
      : super(key: key);
  final TextInputType inputType;
  final bool isPass;
  final String hint;
  final String label;
  final IconData prefixIcon;
  final Widget? suffix;
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
            hintText: hint,
            labelText: label,
            prefixIcon: Icon(
              prefixIcon,
              color: MyColors.primary,
            ),
            suffix:suffix,
        ),
        validator: validate,
        onTap: onTab,
        onSaved: onSave,
      ),
    );
  }
}
