import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:ijot/constants/category.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/snackbar.dart';

class SingleNote extends StatefulWidget {
  final bool? updateMode;
  final Note? note;

  const SingleNote({
    Key? key,
    this.updateMode = false,
    this.note,
  }) : super(key: key);

  @override
  SingleNoteState createState() => SingleNoteState();
}

class SingleNoteState extends State<SingleNote> {
  String? _noteCat;
  String? _noteTitle;
  String? _noteDetails;

  @override
  void initState() {
    _noteCat = widget.updateMode! ? widget.note!.category : 'Uncategorized';
    _noteTitle = widget.updateMode! ? widget.note!.title : '';
    _noteDetails = widget.updateMode! ? widget.note!.details : '';
    super.initState();
  }

  final _categories = [
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
                const SizedBox(width: 6.0),
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
    bool screenGreaterThan700 = MediaQuery.of(context).size.width > 700;

    return CustomScaffold(
      title: widget.updateMode! ? 'note_edit'.tr() : 'note_new'.tr(),
      hasTopBars: true,
      hasBottomBars: true,
      editMode: true,
      child: Container(
        margin: screenGreaterThan700
            ? null
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(2, 2),
              color: Color(0x40000000),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _noteTitle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'note_add_title'.tr(),
                      hintStyle: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      _noteTitle = value;
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 4.0),
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: categoryColor(_noteCat).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: PopupMenuButton(
                    itemBuilder: _buildPopUpMenuItems,
                    onSelected: (dynamic value) {
                      setState(() {
                        _noteCat = value;
                      });
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: categoryColor(_noteCat),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          getCategoryString(_noteCat!),
                          style: TextStyle(
                            color: categoryColor(_noteCat),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: TextFormField(
                initialValue: _noteDetails,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'note_add_details'.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                onChanged: (value) {
                  _noteDetails = value;
                },
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (_noteTitle!.isNotEmpty) {
          var id = const Uuid().v4();
          Note newNote = Note(
            id: widget.updateMode! ? widget.note!.id : id,
            title: _noteTitle,
            details: _noteDetails,
            category: _noteCat,
            dateTime: DateTime.now().toString(),
            ownerId: loggedInUserId,
          );

          if (widget.updateMode!) {
            HiveService().updateNote(note: newNote);
          } else {
            HiveService().addNote(newNote);
          }

          Navigator.pop(context);
        } else {
          showErrorSnackbar(context,
              title: 'note_add_note'.tr(),
              message: 'note_add_note_message'.tr());
        }
      },
    );
  }
}
