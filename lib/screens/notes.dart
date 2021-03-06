import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/models/note.dart';
import 'package:iJot/screens/single_note.dart';
import 'package:iJot/widgets/custom_scaffold.dart';
import 'package:iJot/widgets/note_container.dart';
import 'package:easy_localization/easy_localization.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Widget noContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Image.asset(
          'assets/images/not_found.png',
          height: 177.0,
        )),
        SizedBox(height: 8.0),
        Text(
          'no_notes_yet'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Note>('notes').listenable(),
      builder: (BuildContext context, Box<Note> notesBox, _) {
        return kUserItemsAvailable && notesBox.length > 0
            ? ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: notesBox.length,
                itemBuilder: (BuildContext context, int index) {
                  int noteIndex = notesBox.length - index - 1;
                  final note = notesBox.getAt(noteIndex);
                  if (note.ownerId == loggedInUserId) {
                    return NoteContainer(note, noteIndex);
                  }
                  return SizedBox.shrink();
                },
              )
            : noContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'notes'.tr(),
      child: _buildListView(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleNote(),
          ),
        );
      },
    );
  }
}
