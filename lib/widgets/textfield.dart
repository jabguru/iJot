import 'package:flutter/material.dart';
import 'package:ijot/constants/constants.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    this.validator,
    this.onSaved,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    super.key,
  });
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onSaved;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        style: kInputTextStyle,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: kTextFieldDecoration.copyWith(
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
