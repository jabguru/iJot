import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iJot/constants/routes.dart';
import 'package:iJot/constants/supported_locales.dart';
import 'package:iJot/methods/hive.dart';
import 'package:iJot/screens/change_language.dart';
import 'package:iJot/screens/login.dart';
import 'package:iJot/screens/notes.dart';
import 'package:iJot/screens/register.dart';
import 'package:iJot/screens/single_note.dart';
import 'package:iJot/screens/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart'
    show VxInformationParser, VxNavigator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await HiveMethods().initialize();
  setPathUrlStrategy();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: supportedLocales,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iJot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF410E61),
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'cabin',
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // home: SplashScreen(),
      routeInformationParser: VxInformationParser(),
      routerDelegate: VxNavigator(routes: {
        "/": (uri, params) => MaterialPage(child: SplashScreen()),
        MyRoutes.loginRoute: (uri, params) => MaterialPage(child: Login()),
        MyRoutes.registerRoute: (uri, params) =>
            MaterialPage(child: Register()),
        MyRoutes.notesRoute: (uri, params) => MaterialPage(child: Notes()),
        MyRoutes.noteRoute: (uri, params) {
          return MaterialPage(
            child: params != null
                ? SingleNote(
                    updateMode: params['updateMode'],
                    note: params['note'],
                    noteIndex: params['noteIndex'],
                  )
                : SingleNote(),
          );
        },
        MyRoutes.languageRoute: (uri, params) {
          return MaterialPage(
            child: params != null
                ? ChangeLanguage(
                    isFirstOpen: params['isFirstOpen'],
                  )
                : ChangeLanguage(),
          );
        },
      }),
    );
  }
}
