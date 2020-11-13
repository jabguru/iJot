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

const kCircularBorderRadius = 8.0;

LinearGradient kLinearGradient = LinearGradient(
  colors: [
    Color(0x80EEAAC2),
    Color(0x80410E61),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

bool kUserItemsAvailable = false;
String loggedInUserId;
