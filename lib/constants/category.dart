import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';

Color categoryColor(String? category) {
  if (category == 'Uncategorized') {
    return kPrimaryColor;
  } else if (category == 'Study') {
    return kStudyColor;
  } else if (category == 'Personal') {
    return kPersonalColor;
  } else if (category == 'Work') {
    return kWorkColor;
  } else if (category == 'Todo') {
    return kTodoColor;
  }
  return kPrimaryColor;
}

String getCategoryString(String? category) {
  switch (category) {
    case 'Uncategorized':
      return 'note_cat_uncategorized'.tr();
    case 'Study':
      return 'note_cat_study'.tr();
    case 'Personal':
      return 'note_cat_personal'.tr();
    case 'Work':
      return 'note_cat_work'.tr();
    case 'Todo':
      return 'note_cat_todo'.tr();
    default:
      return 'note_cat_uncategorized'.tr();
  }
}
