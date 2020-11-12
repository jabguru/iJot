import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const kInputTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xFFBEBEBE),
);

const kCircularBorderRadius = 8.0;

bool kUserItemsAvailable = false;
var firstTimeBox = Hive.box('firstOpen');
