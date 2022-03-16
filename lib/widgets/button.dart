import 'package:flutter/material.dart';

import 'package:ijot/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color? textColor;
  final String? text;
  final Function onTap;
  final Widget? child;
  const CustomButton({
    Key? key,
    required this.buttonColor,
    this.textColor,
    this.text,
    required this.onTap,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(kCircularBorderRadius),
          ),
          child: Center(
            child: child ??
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: textColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}