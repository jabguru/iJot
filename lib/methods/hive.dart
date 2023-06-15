import 'package:hive/hive.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/methods/firebase.dart';
import 'package:ijot/models/note.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;

class HiveMethods {
  Future initialize() async {
    if (!kIsWeb) {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    Hive.registerAdapter(NoteAdapter());

    await openBoxes();
    await updateNoteBoxForOldBuilds();

    String? userId = userBox.get('userId');
    if (userId != null) {
      loggedInUserId = userId;
      await checkForUserItems();
      FirebaseMethods().cloudToLocal();
      // FirebaseMethods().deleteNotesDeletedFromOtherDevices();
    }
  }

  Future openBoxes() async {
    await Hive.openBox('user');
    await Hive.openBox<Note>(
      'notes',
      compactionStrategy: (int total, int deleted) {
        return deleted > 20;
      },
    );
    await Hive.openBox('firstOpen');
  }

  Future checkForUserItems() async {
    kUserItemsAvailable = false;
    for (var i = 0; i < notesBox.length; i++) {
      if (loggedInUserId == notesBox.getAt(i)!.ownerId) {
        kUserItemsAvailable = true;
      }
    }
  }

  Future addNote(Note note, {bool sync = true}) async {
    final notesBox = Hive.box<Note>('notes');
    notesBox.put(note.id, note);
    if (!kUserItemsAvailable) {
      kUserItemsAvailable = true;
    }
    if (sync) {
      FirebaseMethods().syncNote(note);
    }
  }

  Future updateNote({required Note note}) async {
    final notesBox = Hive.box<Note>('notes');
    await notesBox.put(note.id, note);
    FirebaseMethods().updateNote(note);
  }

  Future deleteNote({required Note note}) async {
    final noteBox = Hive.box<Note>('notes');
    noteBox.delete(note.id);
    FirebaseMethods().deleteNote(note);
  }

  Future updateNoteBoxForOldBuilds() async {
    bool? hasUpdatedNoteBoxForOldBuilds =
        userBox.get('hasUpdatedNoteBoxForOldBuilds');

    if (!(hasUpdatedNoteBoxForOldBuilds != null &&
        hasUpdatedNoteBoxForOldBuilds)) {
      List<Note> allNotes = notesBox.values.toList();
      if (allNotes.isNotEmpty) {
        notesBox.clear();
        for (Note note in allNotes) {
          addNote(note, sync: false);
        }
      }
      userBox.put('hasUpdatedNoteBoxForOldBuilds', true);
    }
  }
}
