import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ijot/screens/change_language.dart';

import 'test_helper.dart';

Widget createChangeLanguageScreen({required bool isFirstOpen}) =>
    TestHelper.createScreen(
      ChangeLanguage(
        isFirstOpen: isFirstOpen,
      ),
    );

void main() async {
  setUpAll(() async {
    await TestHelper.setUpAll();
  });

  group('Change Language Screen Widget Tests', () {
    testWidgets(
      "Testing if Widgets are rendered properly on first open ",
      (tester) async {
        await tester.pumpWidget(createChangeLanguageScreen(isFirstOpen: true));
        expect(find.text('select_language'.tr()), findsOneWidget);
        expect(find.text('language_continue'.tr()), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      },
    );

    testWidgets(
      "Testing if Widgets are rendered properly when its not first open ",
      (tester) async {
        await tester.pumpWidget(createChangeLanguageScreen(isFirstOpen: false));
        expect(find.text('change_language'.tr()), findsOneWidget);
        expect(find.text('language_done'.tr()), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      },
    );
  });
}
