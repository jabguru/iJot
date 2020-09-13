import 'package:flutter/material.dart';

Color categoryColor(String category) {
  switch (category) {
    case 'Uncategorized':
      return Color(0xFF410E61);
      break;
    case 'Study':
      return Color(0xFF2E8E16);
      break;
    case 'Personal':
      return Color(0xFF166A8E);
      break;
    case 'Work':
      return Color(0xFFC88B15);
      break;
    case 'Todo':
      return Color(0xFF8E1D16);
      break;
    default:
      return Color(0xFF410E61);
  }
}
