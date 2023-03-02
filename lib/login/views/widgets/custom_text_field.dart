import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController myController;
  final TextInputType type;
  final bool isPassword;
  final void Function(String?)? onSave;

  // IconData prefixIcon;

  final String? Function(String? value) validate;

  const MyTextField(
      {Key? key,
      this.hint,
      this.isPassword = false,
      this.type = TextInputType.text,
      required this.myController,
      required this.validate,
       this.onSave
      // required this.prefixIcon,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.primary)),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.primary),
          // borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.primary)),
        hintText: hint ?? '',
        hintStyle: Theme.of(context).textTheme.displaySmall,
        // prefixIcon: Icon(prefixIcon),
        // prefixIconColor: const Color(0xffd8d8d8),
        contentPadding: const EdgeInsets.all(15),
      ),
      onSaved: onSave,
      controller: myController,
      keyboardType: type,
      // TextInputType.multiline
      validator: validate,
      obscureText: isPassword,
    );
  }
}
