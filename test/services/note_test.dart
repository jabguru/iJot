import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/services/note.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseService extends Mock implements FirebaseFirestoreService {}

void main() {
  late HiveService hiveService;
  late MockFirebaseService mockFirebaseService;
  late NoteService sut;
  late Note testNote;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    hiveService = HiveService();
    await hiveService.initialize(isTest: true);

    mockFirebaseService = MockFirebaseService();

    sut = NoteService(
      hiveService: hiveService,
      firebaseFirestoreService: mockFirebaseService,
      loggedInUserId: 'testUserId',
    );

    testNote = Note(
      id: 'testNoteId',
      title: 'Note Title',
      details: 'Note Details',
      category: 'Note Category',
      dateTime: DateTime.now().toString(),
      ownerId: 'testUserId',
      detailsJSON: jsonEncode([
        {'note': 'Note Details'}
      ]),
    );
  });

  group('Testing Note Service', () {
    void arrangeFirebaseServiceSyncNote(
        {required Note note, required String userId}) {
      when(() => mockFirebaseService.syncNote(note: note, userId: userId))
          .thenAnswer(
        (_) async => log('synced note ${note.id}'),
      );
    }

    void arrangeFirebaseServiceDeleteNote(
        {required Note note, required String userId}) {
      when(() => mockFirebaseService.deleteNote(note: note, userId: userId))
          .thenAnswer(
        (_) async => log('deleted note ${note.id}'),
      );
    }

    final noteDocs = [
      {
        'id': 'Id 1',
        'title': 'Title 1',
        'details': 'Details 1',
        'category': 'Category 1',
        'dateTime': Timestamp.fromDate(DateTime.now()),
        'ownerId': 'testUserId',
      },
      {
        'id': 'Id 2',
        'title': 'Title 2',
        'details': 'Details 2',
        'category': 'Category 2',
        'dateTime': Timestamp.fromDate(DateTime.now()),
        'ownerId': 'testUserId',
      },
    ];

    void arrangeFirebaseServiceGetUserNotes(String userId) {
      when(() => mockFirebaseService.getUserNotes(userId)).thenAnswer(
        (_) async => noteDocs,
      );
    }

    void arrangeFirebaseServiceGetOneUserNote(String userId) {
      when(() => mockFirebaseService.getUserNotes(userId)).thenAnswer(
        (_) async => [noteDocs[0]],
      );
    }

    test(
      "Check to make sure user has no existing notes",
      () async {
        sut.checkForUserItems();
        expect(NoteService.userItemsAvailable, false);
      },
    );

    test(
      "A new note should be added and make sure user has an existing note",
      () async {
        arrangeFirebaseServiceSyncNote(
            note: testNote, userId: sut.loggedInUserId!);
        sut.addNote(testNote);

        expect(sut.notesBox.get(testNote.id)!.title, testNote.title);
        expect(NoteService.userItemsAvailable, true);
      },
    );

    test(
      "A note should be updated",
      () async {
        arrangeFirebaseServiceSyncNote(
            note: testNote, userId: sut.loggedInUserId!);

        String title = 'Updated Title';
        String details = 'Updated Details';
        String category = 'Updated Category';
        String dateTime = DateTime.now().toString();
        String detailsJSON = jsonEncode([
          {'note': details}
        ]);

        sut.updateNote(
          note: testNote.copyWith(
            title: title,
            details: details,
            category: category,
            dateTime: dateTime,
            detailsJSON: detailsJSON,
          ),
        );

        expect(sut.notesBox.get(testNote.id)!.title, title);
        expect(sut.notesBox.get(testNote.id)!.details, details);
        expect(sut.notesBox.get(testNote.id)!.category, category);
        expect(sut.notesBox.get(testNote.id)!.dateTime, dateTime);
        expect(sut.notesBox.get(testNote.id)!.detailsJSON, detailsJSON);
      },
    );

    test(
      "A note should be deleted",
      () async {
        arrangeFirebaseServiceDeleteNote(
            note: testNote, userId: sut.loggedInUserId!);

        sut.deleteNote(
          note: testNote,
        );

        expect(sut.notesBox.get(testNote.id), null);
      },
    );

    test(
      "Get notes from firestore to local storage and also delete the note that does not exist in firestore",
      () async {
        //? CLOUD TO LOCAL
        arrangeFirebaseServiceGetUserNotes(sut.loggedInUserId!);
        await sut.cloudToLocal();
        expect(sut.notesBox.length, 2);

        // ? DELETE NOTES DELETED FROM OTHER DEVICES
        arrangeFirebaseServiceGetOneUserNote(sut.loggedInUserId!);
        await sut.deleteNotesDeletedFromOtherDevices();
        expect(sut.notesBox.length, 1);
      },
    );
  });
}
