import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCircularBorderRadius),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            offset: Offset(2, 2),
            color: kBlackColor,
          ),
        ],
      ),
      child: child,
    );
  }
}
