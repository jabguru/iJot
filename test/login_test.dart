import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() async {
  setUpAll(() async {
    await TestHelper.setUpAll();
  });

  // testWidgets(
  //   "Testing if Widgets are rendered properly",
  //   (tester) async {
  //     await tester.pumpWidget(
  //       TestHelper.createScreen(
  //         const Login(),
  //       ),
  //     );
  //     expect(find.byType(TextFieldWidget), findsNWidgets(2));
  //     expect(find.text('sign_in'.tr()), findsNWidgets(2));
  //     expect(find.text('register'.tr()), findsOneWidget);
  //   },
  // );
}
