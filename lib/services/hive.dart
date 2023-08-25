import 'dart:io';

import 'package:hive/hive.dart';
import 'package:ijot/models/note.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;

class HiveService {
  static Box get firstTimeBox => Hive.box('firstOpen');
  Box get userBox => Hive.box('user');
  Box<Note> get notesBox => Hive.box<Note>('notes');

  Future initialize({bool isTest = false}) async {
    if (!kIsWeb) {
      late String fullPath;
      if (isTest) {
        var path = Directory.current.path;
        fullPath = '$path/test/hive_testing_path';

        // delete the hive box if it exits first
        final Directory dir = Directory(fullPath);
        if (dir.existsSync()) {
          dir.deleteSync(recursive: true);
        }
      } else {
        final appDocumentDir =
            await path_provider.getApplicationDocumentsDirectory();
        fullPath = appDocumentDir.path;
      }
      Hive.init(fullPath);
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
