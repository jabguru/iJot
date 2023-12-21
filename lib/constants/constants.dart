import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';

const kInputTextStyle = TextStyle(
  fontSize: 20.0,
  color: kGrey3,
);

const kTitleTextStyle = TextStyle(
  color: kPurpleDark1,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kNormalUnderlineTextStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
  decorationColor: Colors.white,
  decoration: TextDecoration.underline,
  fontFamily: 'Cabin',
);

const kPrimaryTextStyle = TextStyle(
  fontSize: 16.0,
  color: kPrimaryColor,
);

const kCircularBorderRadius = 8.0;

LinearGradient kLinearGradient = const LinearGradient(
  colors: [
    Color(0x80EEAAC2),
    Color(0x80410E61),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

var kModalBoxDecoration = const BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  ),
  color: Colors.white,
);

var kModalBoxDecorationGradient = BoxDecoration(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  ),
  gradient: kLinearGradient,
);

GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

String? Function(String?)? kEmailValidator = (val) {
  if (val!.trim().isEmpty) {
    return 'validation_email'.tr();
  } else if (!val.trim().contains(RegExp(
      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
      caseSensitive: false))) {
    return 'validation_email_2'.tr();
  } else {
    return null;
  }
};

String? Function(String?)? kPasswordValidator = (val) {
  if (val!.trim().isEmpty) {
    return 'validation_password'.tr();
  } else if (val.trim().length < 6) {
    return 'validation_password_2'.tr();
  } else {
    return null;
  }
};

InputDecoration kTextFieldDecoration = const InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: InputBorder.none,
  errorStyle: TextStyle(
    color: kPrimaryColor,
  ),
);
