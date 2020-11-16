import 'package:flutter/material.dart';
import 'package:iJot/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final String text;
  final Function onTap;
  CustomButton({
    @required this.buttonColor,
    @required this.text,
    @required this.textColor,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.0,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
