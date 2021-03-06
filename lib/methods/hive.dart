import 'package:hive/hive.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/hive.dart';
import 'package:iJot/methods/firebase.dart';
import 'package:iJot/models/note.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

class HiveMethods {
  Future initialize() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(NoteAdapter());
    await openBoxes();
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
      if (loggedInUserId == notesBox.getAt(i).ownerId) {
        kUserItemsAvailable = true;
      }
    }
  }

  Future addNote(Note note) async {
    final notesBox = Hive.box<Note>('notes');
    notesBox.add(note);
    if (!kUserItemsAvailable) {
      kUserItemsAvailable = true;
    }
    FirebaseMethods().syncNote(note);
  }

  Future updateNote({Note note, index}) async {
    final notesBox = Hive.box<Note>('notes');
    notesBox.putAt(index, note);
    FirebaseMethods().updateNote(note);
  }

  Future deleteNote({Note note, index}) async {
    final noteBox = Hive.box<Note>('notes');
    noteBox.deleteAt(index);
    FirebaseMethods().deleteNote(note);
  }
}
