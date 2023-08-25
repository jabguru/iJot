import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/firebase_storage.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/services/version.dart';

class NoteService {
  NoteService({
    required this.hiveService,
    required this.firebaseFirestoreService,
    required this.loggedInUserId,
  });

  final FirebaseFirestoreService firebaseFirestoreService;
  final HiveService hiveService;
  final String? loggedInUserId;

  static bool userItemsAvailable = false;
  Box<Note> get notesBox => hiveService.notesBox;

  static initialize(userId) async {
    if (userId != null) {
      NoteService noteService = NoteService(
        hiveService: HiveService(),
        firebaseFirestoreService: FirebaseFirestoreService(),
        loggedInUserId: userId,
      );
      await noteService.updateNoteBoxForOldBuilds(VersionService());
      await noteService.checkForUserItems();
      noteService.cloudToLocal();
      noteService.deleteNotesDeletedFromOtherDevices();
    }
  }

  Future checkForUserItems() async {
    userItemsAvailable = false;
    for (var i = 0; i < notesBox.length; i++) {
      if (loggedInUserId == notesBox.getAt(i)!.ownerId) {
        userItemsAvailable = true;
      }
    }
  }

  Future addNote(Note note, {bool sync = true}) async {
    notesBox.put(note.id, note);
    if (!userItemsAvailable) {
      userItemsAvailable = true;
    }
    if (sync) {
      firebaseFirestoreService.syncNote(note: note, userId: loggedInUserId!);
    }
  }

  Future updateNote({required Note note}) async {
    await notesBox.put(note.id, note);
    firebaseFirestoreService.updateNote(note: note, userId: loggedInUserId!);
  }

  Future deleteNote({required Note note}) async {
    notesBox.delete(note.id);
    firebaseFirestoreService.deleteNote(note: note, userId: loggedInUserId!);
    deletePhotos(note);
  }

  Future updateNoteBoxForOldBuilds(VersionService versionService) async {
    bool appIsGreaterThanV2 = await versionService.isGreaterThanV2();

    if (!appIsGreaterThanV2) {
      bool hasUpdatedNoteBoxForOldBuilds =
          hiveService.userBox.get('hasUpdatedNoteBoxForOldBuilds') ?? false;

      if (!(hasUpdatedNoteBoxForOldBuilds)) {
        List<Note> allNotes = notesBox.values.toList();
        if (allNotes.isNotEmpty) {
          notesBox.clear();
          for (Note note in allNotes) {
            addNote(note, sync: false);
          }
        }
        hiveService.userBox.put('hasUpdatedNoteBoxForOldBuilds', true);
      }
    }
  }

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

  cloudToLocal() async {
    try {
      if (loggedInUserId != null) {
        final docs =
            await firebaseFirestoreService.getUserNotes(loggedInUserId!);

        for (var doc in docs) {
          bool isContained = false;
          bool isUnchanged = false;
          Note cloudNote = Note.fromDocument(doc);
          for (var i = 0; i < notesBox.length; i++) {
            if (loggedInUserId == notesBox.getAt(i)!.ownerId) {
              if (cloudNote.id == notesBox.getAt(i)!.id) {
                isContained = true;
              }
              if (cloudNote == notesBox.getAt(i)) {
                isUnchanged = true;
              }
            }
          }
          if (!isContained || !isUnchanged) {
            notesBox.put(cloudNote.id, cloudNote);
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  deleteNotesDeletedFromOtherDevices() async {
    final docs = await firebaseFirestoreService.getUserNotes(loggedInUserId!);

    List<Note> cloudNotes =
        docs.map((var doc) => Note.fromDocument(doc)).toList();

    for (var i = 0; i < notesBox.length; i++) {
      if (loggedInUserId == notesBox.getAt(i)!.ownerId) {
        Iterable<Note> containedNotes =
            cloudNotes.where((Note note) => note.id == notesBox.getAt(i)!.id);
        if (containedNotes.isEmpty) {
          notesBox.deleteAt(i);
        }
      }
    }
  }
}
