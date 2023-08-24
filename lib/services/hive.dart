import 'package:hive/hive.dart';
import 'package:ijot/models/note.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;

class HiveService {
  static Box get firstTimeBox => Hive.box('firstOpen');
  Box get userBox => Hive.box('user');
  Box<Note> get notesBox => Hive.box<Note>('notes');

  Future initialize() async {
    if (!kIsWeb) {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

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

  Future clearUserBox() async {
    await notesBox.clear();
  }
}
