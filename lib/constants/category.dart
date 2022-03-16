import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Color categoryColor(String? category) {
  if (category == 'note_cat_uncategorized'.tr()) {
    return const Color(0xFF410E61);
  } else if (category == 'note_cat_study'.tr()) {
    return const Color(0xFF2E8E16);
  } else if (category == 'note_cat_personal'.tr()) {
    return const Color(0xFF166A8E);
  } else if (category == 'note_cat_work'.tr()) {
    return const Color(0xFFC88B15);
  } else if (category == 'note_cat_todo'.tr()) {
    return const Color(0xFF8E1D16);
  }
  return const Color(0xFF410E61);
}
