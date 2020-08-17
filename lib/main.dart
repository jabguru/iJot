import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iJot/models/note.dart';
import 'package:iJot/screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iJot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF410E61),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'cabin',
      ),
      home: SplashScreen(),
    );
  }
}
