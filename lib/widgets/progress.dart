import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ijot/constants/colors.dart';

Widget circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 10.0),
    child: const SpinKitCircle(
      color: kPrimaryColor,
    ),
  );
}
