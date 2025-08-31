import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ijot/screens/single_note.dart';
import 'package:ijot/services/hive.dart';

import 'test_helper.dart';

Widget createSingleNoteScreen() => TestHelper.createScreen(const SingleNote());

void main() async {
  late HiveService hiveService;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestHelper.setUpAll();
    hiveService = HiveService();
    await hiveService.initialize(isTest: true);
  });

  // testWidgets("Testing if Single Note Screen is rendered properly", (
  //   tester,
  // ) async {
  //   await tester.pumpWidget(createSingleNoteScreen());
  //   // ? i feel this pump is needed here because of the animation in customscaffold (button)
  //   await tester.pump(const Duration(milliseconds: 500));

  //   // ? title formfield
  //   expect(find.byType(TextFormField), findsOneWidget);
  //   // ? category popupmenubutton
  //   expect(find.byType(PopupMenuButton<dynamic>), findsOneWidget);
  //   expect(find.byType(quill.QuillSimpleToolbar), findsOneWidget);
  //   expect(find.byType(quill.QuillEditor), findsOneWidget);
  //   expect(find.byType(WhatsappCopyButton), findsOneWidget);
  // });
}
