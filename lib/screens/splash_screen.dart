import 'package:flutter/material.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/methods/firebase.dart';
import 'package:ijot/methods/hive.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNavigation();
    });
  }

  handleNavigation() async {
    String userId = userBox.get('userId');
    if (userId == null) {
      if (firstTimeBox.isEmpty) {
        await context.vxNav.replace(
          Uri.parse(MyRoutes.languageRoute),
          params: {
            'isFirstOpen': true,
          },
        );
      } else {
        await context.vxNav.replace(Uri.parse(MyRoutes.loginRoute));
      }
    } else {
      loggedInUserId = userId;

      await HiveMethods().checkForUserItems();
      // not awaiting cloudtolocal so as not to delay moving to screen
      FirebaseMethods().cloudToLocal();
      await context.vxNav.replace(Uri.parse(MyRoutes.notesRoute));
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
