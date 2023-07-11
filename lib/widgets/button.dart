import 'package:flutter/material.dart';

import 'package:ijot/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color? textColor;
  final String? text;
  final VoidCallback onTap;
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
      onTap: onTap,
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

class CustomButton2 extends StatelessWidget {
  final Color buttonColor;
  final Color? textColor;
  final String text;
  final VoidCallback onTap;
  final BoxBorder? border;
  const CustomButton2({
    Key? key,
    required this.buttonColor,
    required this.textColor,
    required this.text,
    required this.onTap,
    this.border,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 21.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              border: border,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
              ),
            ),
          )),
    );
  }
}
