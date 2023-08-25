import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/screens/notes.dart';
import 'package:ijot/screens/single_note.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/services/note.dart';
import 'package:ijot/widgets/note/whatsapp_copy.dart';
import 'package:ijot/widgets/note_container.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/test_helper.dart';

class MockFirebaseService extends Mock implements FirebaseFirestoreService {}

Widget createNotesScreen() => TestHelper.createScreenWithGoRouter(router);
String noteRoute = "note";

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesScreenContent(
        loggedInUserId: 'testUserId',
      ),
      routes: [
        GoRoute(
          path: noteRoute,
          builder: (context, state) => const SingleNote(),
        ),
        GoRoute(
          path: '$noteRoute/:noteId',
          builder: (context, state) {
            if (state.extra != null) {
              Map params = state.extra as Map;
              return SingleNote(
                note: params['note'],
              );
            }
            return const SingleNote();
          },
        ),
      ],
    ),
  ],
);

void main() {
  late HiveService hiveService;
  late MockFirebaseService mockFirebaseService;
  late NoteService sut;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestHelper.setUpAll();

    hiveService = HiveService();
    await hiveService.initialize();
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
        ),
        sync: false,
      );
    }
  });

  group('Testing App', () {
    testWidgets(
      "Navigating to single note screen",
      (tester) async {
        await tester.pumpWidget(createNotesScreen());
        // ? i feel this pump is needed here because of the animation in customscaffold (button)
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byType(NoteContainer).first);

        await tester.pumpAndSettle();

        // ? title formfield
        expect(find.byType(TextFormField), findsOneWidget);
        // ? category popupmenubutton
        expect(find.byType(PopupMenuButton<dynamic>), findsOneWidget);
        expect(find.byType(quill.QuillToolbar), findsOneWidget);
        expect(find.byType(quill.QuillEditor), findsOneWidget);
        expect(find.byType(WhatsappCopyButton), findsOneWidget);
      },
    );
  });
}
