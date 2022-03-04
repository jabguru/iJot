import 'package:flutter/material.dart';
import 'package:ijot/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final String text;
  final Function onTap;
  final Widget child;
  CustomButton({
    @required this.buttonColor,
    this.text,
    this.textColor,
    @required this.onTap,
    this.child,
  });
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
            child: child == null
                ? Text(
                    text,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: textColor,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
