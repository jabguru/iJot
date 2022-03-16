import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/note_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:velocity_x/velocity_x.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

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
        const SizedBox(height: 8.0),
        Text(
          'no_notes_yet'.tr(),
          style: const TextStyle(
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
            ? LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 700) {
                  return GridView.builder(
                      padding: const EdgeInsets.only(right: 8.0),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisExtent: 120.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemCount: notesBox.length,
                      itemBuilder: (BuildContext context, int index) {
                        int noteIndex = notesBox.length - index - 1;
                        final note = notesBox.getAt(noteIndex)!;
                        if (note.ownerId == loggedInUserId) {
                          return NoteContainer(note, noteIndex);
                        }
                        return const SizedBox.shrink();
                      });
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  itemCount: notesBox.length,
                  itemBuilder: (BuildContext context, int index) {
                    int noteIndex = notesBox.length - index - 1;
                    final note = notesBox.getAt(noteIndex)!;
                    if (note.ownerId == loggedInUserId) {
                      return NoteContainer(note, noteIndex);
                    }
                    return const SizedBox.shrink();
                  },
                );
              })
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
        context.vxNav.push(Uri.parse(MyRoutes.noteRoute));
      },
    );
  }
}
