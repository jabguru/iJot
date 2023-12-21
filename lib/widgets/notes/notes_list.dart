import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/services/note.dart';
import 'package:ijot/widgets/note_container.dart';
import 'package:ijot/widgets/notes/no_content.dart';

class NotesListWidget extends StatelessWidget {
  final ScrollController? scrollController;
  final String? searchText;
  final String category;
  final String? loggedInUserId;

  const NotesListWidget({
    required this.scrollController,
    required this.searchText,
    required this.category,
    required this.loggedInUserId,
    super.key,
  });

  Widget noteItemBuilder({
    required Note note,
    required int index,
  }) {
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
        List<Note> allNotes = notesBox.values.toList();
        if (category != 'All') {
          allNotes =
              allNotes.where((Note note) => note.category == category).toList();
        }
        if (searchText != null && searchText!.isNotEmpty) {
          allNotes = allNotes
              .where((Note note) => (note.title!
                      .toLowerCase()
                      .contains(searchText!.toLowerCase()) ||
                  note.details!
                      .toLowerCase()
                      .contains(searchText!.toLowerCase())))
              .toList();
        }

        allNotes.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));

        return NoteService.userItemsAvailable && allNotes.isNotEmpty
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
                        itemCount: allNotes.length,
                        itemBuilder: (BuildContext context, int index) =>
                            noteItemBuilder(
                          note: allNotes[index],
                          index: index,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: allNotes.length,
                    itemBuilder: (BuildContext context, int index) =>
                        noteItemBuilder(
                      note: allNotes[index],
                      index: index,
                    ),
                  );
                },
              )
            : NoContentWidget(
                searchText: searchText,
              );
      },
    );
  }
}
