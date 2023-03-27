import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController myController;
  final TextInputType type;
  final bool isPassword;
  final void Function(String?)? onSave;
  final IconData? suffixIcon;
 final Function()? suffixPress;
  final String? Function(String? value) validate;
  final Function(String)? onSubmit;

  const MyTextField({
    Key? key,
    this.hint,
    required this.isPassword,
    this.type = TextInputType.text,
    required this.myController,
    required this.validate,
    this.onSave,
    this.suffixIcon,
    this.suffixPress,
    this.onSubmit,
  }) : super(key: key);

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
        suffixIcon:suffixIcon!=null? IconButton(
          icon: Icon(
            suffixIcon,
            color: MyColors.black,
          ),
          onPressed: suffixPress,
        ):null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 6),
      ),
      onSaved: onSave,
      controller: myController,
      keyboardType: type,
      validator: validate,
      obscureText: isPassword,
      onFieldSubmitted:onSubmit ,
    );
  }
}
