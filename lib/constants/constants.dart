import 'package:flutter/material.dart';

const kInputTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xFFBEBEBE),
);

const kTitleTextStyle = TextStyle(
  color: Color(0xFF1D062A),
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kNormalUnderlineTextStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
  decoration: TextDecoration.underline,
  fontFamily: 'Cabin',
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

bool kUserItemsAvailable = false;
String? loggedInUserId;

GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");
