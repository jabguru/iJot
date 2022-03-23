import 'package:beamer/beamer.dart';
import 'package:ijot/screens/change_language.dart';
import 'package:ijot/screens/login.dart';
import 'package:ijot/screens/notes.dart';
import 'package:ijot/screens/register.dart';
import 'package:ijot/screens/single_note.dart';
import 'package:ijot/screens/first_screen_selector.dart';

class MyRoutes {
  static String loginRoute = "/login";
  static String registerRoute = "/register";
  static String notesRoute = "/notes";
  static String noteRoute = "/note";
  static String languageRoute = "/language";

  static BeamerDelegate routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context, state, data) => const FirstScreenSelector(),
        loginRoute: (context, state, data) => const Login(),
        registerRoute: (context, state, data) => const Register(),
        notesRoute: (context, state, data) => const Notes(),
        noteRoute: (context, state, data) => const SingleNote(),
        noteRoute + '/:noteId': (context, state, data) {
          if (data != null) {
            Map params = data as Map;
            return SingleNote(
              updateMode: params['updateMode'],
              note: params['note'],
              noteIndex: params['noteIndex'],
            );
          }
          return const SingleNote();
        },
        languageRoute: (context, state, data) {
          if (data != null) {
            Map params = data as Map;
            return ChangeLanguage(
              isFirstOpen: params['isFirstOpen'] ?? false,
            );
          }
          return const ChangeLanguage(isFirstOpen: false);
        }
      },
    ),
  );
}
