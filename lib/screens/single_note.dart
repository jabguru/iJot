import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iJot/constants/category.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/models/note.dart';
import 'package:iJot/widgets/custom_scaffold.dart';
import 'package:iJot/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';

class SingleNote extends StatefulWidget {
  final bool updateMode;
  final Note note;
  final int noteIndex;

  SingleNote({
    this.updateMode = false,
    this.note,
    this.noteIndex,
  });

  @override
  _SingleNoteState createState() => _SingleNoteState();
}

class _SingleNoteState extends State<SingleNote> {
  String _noteCat;
  String _noteTitle;
  String _noteDetails;

  @override
  void initState() {
    _noteCat = widget.updateMode ? widget.note.category : 'Uncategorized';
    _noteTitle = widget.updateMode ? widget.note.title : '';
    _noteDetails = widget.updateMode ? widget.note.details : '';
    super.initState();
  }

  var _categories = [
    'Uncategorized',
    'Study',
    'Personal',
    'Work',
    'Todo',
  ];
  List<PopupMenuEntry> _buildPopUpMenuItems(BuildContext context) {
    return _categories
        .map(
          (cat) => PopupMenuItem(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10.0,
                  backgroundColor: categoryColor(cat),
                ),
                SizedBox(width: 6.0),
                Text(
                  cat,
                  style: TextStyle(
                    color: categoryColor(cat),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            value: cat,
            height: 30.0,
          ),
        )
        .toList();
  }

  _addNote(Note note) {
    final notesBox = Hive.box<Note>('notes');
    notesBox.add(note);
    if (!kUserItemsAvailable) {
      setState(() {
        kUserItemsAvailable = true;
      });
    }
    syncNote(note);
  }

  _updateNote(Note note) {
    final notesBox = Hive.box<Note>('notes');
    notesBox.putAt(widget.noteIndex, note);
    updateNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: widget.updateMode ? 'Edit' : 'New Note',
      editMode: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
          boxShadow: [
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
                      hintText: 'Add Title...',
                      hintStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      _noteTitle = value;
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: categoryColor(_noteCat).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: PopupMenuButton(
                    itemBuilder: _buildPopUpMenuItems,
                    onSelected: (value) {
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
                        SizedBox(width: 6.0),
                        Text(
                          _noteCat,
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
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.67,
                  child: TextFormField(
                    initialValue: _noteDetails,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add Details...',
                      hintStyle: TextStyle(
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
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (_noteTitle.isNotEmpty) {
          var id = Uuid().v4();
          Note newNote = Note(
            id: widget.updateMode ? widget.note.id : id,
            title: _noteTitle,
            details: _noteDetails,
            category: _noteCat,
            dateTime: DateTime.now().toString(),
            ownerId: loggedInUserId,
          );

          widget.updateMode ? _updateNote(newNote) : _addNote(newNote);
          Navigator.pop(context);
        } else {
          showErrorSnackbar(context,
              title: 'Add note', message: 'Note Must Have a Title');
        }
      },
    );
  }
}
