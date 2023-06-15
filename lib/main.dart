import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/supported_locales.dart';
import 'package:ijot/firebase_options.dart';
import 'package:ijot/methods/hive.dart';
import 'package:url_strategy/url_strategy.dart';

// TODO: SORT THE NOTES BY DATE, SO WHEN A NOTE IS UPDATED IT COMES UP

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveMethods().initialize();
  setPathUrlStrategy();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: supportedLocales,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iJot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'cabin',
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // home: SplashScreen(),
      routeInformationParser: BeamerParser(),
      routerDelegate: MyRoutes.routerDelegate,
      backButtonDispatcher:
          BeamerBackButtonDispatcher(delegate: MyRoutes.routerDelegate),
    );
  }
}
