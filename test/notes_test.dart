import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/screens/notes.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/services/note.dart';
import 'package:ijot/widgets/note_container.dart';
import 'package:ijot/widgets/notes/notes_list.dart';
import 'package:ijot/widgets/search_widget.dart';
import 'package:ijot/widgets/sort_note_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'test_helper.dart';

class MockFirebaseService extends Mock implements FirebaseFirestoreService {}

Widget createNotesScreen() =>
    TestHelper.createScreen(const NotesScreenContent());

Widget createNotesListWidget() => TestHelper.createScreen(
      NotesListWidget(
        scrollController: ScrollController(),
        searchText: null,
        category: 'All',
        loggedInUserId: 'testUserId',
      ),
    );

void main() async {
  late HiveService hiveService;
  late MockFirebaseService mockFirebaseService;
  late NoteService sut;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestHelper.setUpAll();

    hiveService = HiveService();
    await hiveService.initialize(isTest: true);
    mockFirebaseService = MockFirebaseService();
    sut = NoteService(
      hiveService: hiveService,
      firebaseFirestoreService: mockFirebaseService,
      loggedInUserId: 'testUserId',
    );

    // ? fill hive with test notes
    for (var i = 0; i < 50; i++) {
      sut.addNote(
        Note(
          id: 'note_$i',
          title: 'Note Title $i',
          details: 'Note Details  $i',
          category: 'Note Category  $i',
          dateTime: DateTime.now().toString(),
          ownerId: 'testUserId',
          detailsJSON: jsonEncode([
            {'note': 'Note Details'}
          ]),
        ),
        sync: false,
      );
    }
  });

  group('Notes Screen Widget Tests', () {
    testWidgets(
      "Testing if Widgets are rendered properly",
      (tester) async {
        await tester.pumpWidget(createNotesScreen());
        // ? i feel this pump is needed here because of the animation in customscaffold (button)
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(SearchWidget), findsOneWidget);
        expect(find.byType(SortNoteWidget), findsOneWidget);
        expect(find.byType(NotesListWidget), findsOneWidget);
      },
    );

    testWidgets(
      "Testing notes list widget",
      (tester) async {
        FlutterError.onError = TestHelper.ignoreOverflowErrors;

        await tester.pumpWidget(createNotesListWidget());

        expect(find.byType(LayoutBuilder), findsOneWidget);
        expect(find.byType(NoteContainer), findsAtLeastNWidgets(1));

        await tester.fling(
          // ? Gridview for screen larger and mobile screen, ListView for smaller screens
          find.byType(GridView),
          const Offset(0, -200),
          3000,
        );
        await tester.pumpAndSettle();
      },
    );
  });
}
