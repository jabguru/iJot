import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/category.dart';
import 'package:ijot/constants/spaces.dart';

class SortNoteWidget extends StatelessWidget {
  SortNoteWidget({
    super.key,
    required this.onSelected,
    required this.value,
  });
  final ValueChanged onSelected;
  final String value;

  final _categories = [
    {'name': 'note_cat_all'.tr(), 'value': "All"},
    {'name': 'note_cat_uncategorized'.tr(), 'value': "Uncategorized"},
    {'name': 'note_cat_study'.tr(), 'value': "Study"},
    {'name': 'note_cat_personal'.tr(), 'value': "Personal"},
    {'name': 'note_cat_work'.tr(), 'value': "Work"},
    {'name': 'note_cat_todo'.tr(), 'value': "Todo"},
  ];

  List<PopupMenuEntry> _buildPopUpMenuItems(BuildContext context) {
    return _categories
        .map(
          (cat) => PopupMenuItem(
            value: cat['value'],
            height: 30.0,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10.0,
                  backgroundColor: categoryColor(cat['value']),
                ),
                kHSpace6,
                Text(
                  cat['name']!,
                  style: TextStyle(
                    color: categoryColor(cat['value']),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      itemBuilder: _buildPopUpMenuItems,
      onSelected: onSelected,
      tooltip: 'sort_notes'.tr(),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10.0,
            backgroundColor: categoryColor(value),
          ),
          kHSpace6,
          const Icon(Icons.sort)
        ],
      ),
    );
  }
}
