import 'dart:convert';

import 'package:ijot/models/note.dart';
import 'package:ijot/services/firebase_storage.dart';

class NoteService {
  static deletePhotos(Note note) {
    if (note.detailsJSON != null) {
      String noteText = note.detailsJSON!;
      List<dynamic> listOfLines = jsonDecode(noteText);
      List<Map> maps = listOfLines.map((e) => e as Map).where((element) {
        if (element['insert'] is Map) {
          return element['insert'].containsKey('image');
        }
        return false;
      }).toList();

      for (Map map in maps) {
        String url = map['insert']['image'];

        String removeUrl = url.split(FirebaseStorageService.storageUrl)[1];
        String removeExtras = removeUrl.split('?alt=media')[0];
        List<String> uidAndImageName = removeExtras.split('%2F');
        FirebaseStorageService().deleteFile(
          uid: uidAndImageName[0],
          imageName: uidAndImageName[1].replaceAll('%20', ' '),
        );
      }
    }
  }
}
