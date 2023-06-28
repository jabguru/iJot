import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/widgets/note_container.dart';
import 'package:ijot/widgets/notes/no_content.dart';

class NotesListWidget extends StatelessWidget {
  final ScrollController? scrollController;

  const NotesListWidget({
    this.scrollController,
    super.key,
  });

  Widget noteItemBuilder({
    required BuildContext context,
    required Box<Note> notesBox,
    required int index,
  }) {
    List<Note> allNotes = notesBox.values.toList();
    allNotes.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));

    // int noteIndex = notesBox.length - index - 1;
    final note = allNotes[index];
    if (note.ownerId == loggedInUserId) {
      return NoteContainer(note, index);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Note>('notes').listenable(),
      builder: (BuildContext context, Box<Note> notesBox, _) {
        return kUserItemsAvailable && notesBox.length > 0
            ? LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 700) {
                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                      ),
                      child: GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(right: 8.0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisExtent: 120.0,
                          crossAxisSpacing: 20.0,
                        ),
                        itemCount: notesBox.length,
                        itemBuilder: (BuildContext context, int index) =>
                            noteItemBuilder(
                          context: context,
                          notesBox: notesBox,
                          index: index,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: notesBox.length,
                    itemBuilder: (BuildContext context, int index) =>
                        noteItemBuilder(
                      context: context,
                      notesBox: notesBox,
                      index: index,
                    ),
                  );
                },
              )
            : const NoContentWidget();
      },
    );
  }
}
