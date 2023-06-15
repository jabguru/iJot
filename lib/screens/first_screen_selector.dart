import 'package:flutter/material.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/screens/change_language.dart';
import 'package:ijot/screens/login.dart';
import 'package:ijot/screens/notes.dart';

class FirstScreenSelector extends StatefulWidget {
  const FirstScreenSelector({Key? key}) : super(key: key);

  @override
  FirstScreenSelectorState createState() => FirstScreenSelectorState();
}

class FirstScreenSelectorState extends State<FirstScreenSelector> {
  Widget getWidgetToShow() {
    String? userId = userBox.get('userId');
    if (userId == null) {
      if (firstTimeBox.isEmpty) {
        return const ChangeLanguage(isFirstOpen: true);
      } else {
        return const Login();
      }
    } else {
      return const Notes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: getWidgetToShow(),
    );
  }
}
