import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/supported_locales.dart';
import 'package:ijot/methods/hive.dart';
import 'package:ijot/screens/change_language.dart';
import 'package:ijot/screens/login.dart';
import 'package:ijot/screens/notes.dart';
import 'package:ijot/screens/register.dart';
import 'package:ijot/screens/single_note.dart';
import 'package:ijot/screens/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart'
    show VxInformationParser, VxNavigator;

// TODO: SORT THE NOTES BY DATE, SO WHEN A NOTE IS UPDATED IT COMES UP

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
      routeInformationParser: VxInformationParser(),
      routerDelegate: VxNavigator(routes: {
        "/": (uri, params) => const MaterialPage(child: SplashScreen()),
        MyRoutes.loginRoute: (uri, params) =>
            const MaterialPage(child: Login()),
        MyRoutes.registerRoute: (uri, params) =>
            const MaterialPage(child: Register()),
        MyRoutes.notesRoute: (uri, params) =>
            const MaterialPage(child: Notes()),
        MyRoutes.noteRoute: (uri, params) {
          return MaterialPage(
            child: params != null
                ? SingleNote(
                    updateMode: params['updateMode'],
                    note: params['note'],
                    noteIndex: params['noteIndex'],
                  )
                : const SingleNote(),
          );
        },
        MyRoutes.languageRoute: (uri, params) {
          return MaterialPage(
            child: params != null
                ? ChangeLanguage(
                    isFirstOpen: params['isFirstOpen'],
                  )
                : const ChangeLanguage(),
          );
        },
      }),
    );
  }
}
