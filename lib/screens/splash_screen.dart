import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/models/note.dart';
import 'package:iJot/screens/change_language.dart';
import 'package:iJot/screens/login.dart';
import 'package:iJot/screens/notes.dart';
import 'package:iJot/widgets/custom_scaffold.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    handleNavigation();
  }

  _checkForUserItems() {
    for (var i = 0; i < notesBox.length; i++) {
      if (loggedInUserId == notesBox.getAt(i).ownerId) {
        kUserItemsAvailable = true;
      }
    }
    setState(() {});
  }

  handleNavigation() async {
    await Hive.openBox('user');
    await Hive.openBox<Note>(
      'notes',
      compactionStrategy: (int total, int deleted) {
        return deleted > 20;
      },
    );
    await Hive.openBox('firstOpen');
    userBox = Hive.box('user');
    String userId = userBox.get('userId');
    if (userId == null) {
      if (firstTimeBox.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeLanguage(
              isFirstOpen: true,
            ),
          ),
        );
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } else {
      setState(() {
        loggedInUserId = userId;
      });
      await _checkForUserItems();
      // added this newly
      cloudToLocal();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Notes()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        title: 'Splash Screen',
        hasTopBars: false,
        hasBottomBars: false,
        child: Stack(
          children: [
            Positioned(
              bottom: 0.0,
              child: Image.asset(
                'assets/images/watermark.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Image.asset(
              'assets/images/splash-logo.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
