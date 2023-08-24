import 'package:go_router/go_router.dart';
import 'package:ijot/screens/change_language.dart';
import 'package:ijot/screens/delete_account.dart';
import 'package:ijot/screens/login.dart';
import 'package:ijot/screens/notes.dart';
import 'package:ijot/screens/privacy_policy.dart';
import 'package:ijot/screens/register.dart';
import 'package:ijot/screens/single_note.dart';
import 'package:ijot/services/account.dart';
import 'package:ijot/services/hive.dart';

class MyRoutes {
  static String homeRoute = '/';
  static String loginRoute({bool redirectToDeleteAccount = false}) =>
      redirectToDeleteAccount
          ? "/login?redirectToDeleteAccount=$redirectToDeleteAccount"
          : '/login';
  static String registerRoute = "/register";
  static String noteRoute = "note";
  static String languageRoute({bool firstOpen = false}) =>
      firstOpen ? "/language?firstOpen=$firstOpen" : "/language";
  static String privacyPolicyRoute = "/privacy-policy";
  static String deleteAccountRoute = "/delete-account";

  static final router = GoRouter(
    routes: [
      GoRoute(
          path: homeRoute,
          builder: (context, state) => const Notes(),
          routes: [
            GoRoute(
              path: noteRoute,
              builder: (context, state) => const SingleNote(),
            ),
            GoRoute(
              path: '$noteRoute/:noteId',
              builder: (context, state) {
                if (state.extra != null) {
                  Map params = state.extra as Map;
                  return SingleNote(
                    note: params['note'],
                  );
                }
                return const SingleNote();
              },
            ),
          ],
          redirect: (context, state) {
            if (AccountService.loggedInUserId == null) {
              if (HiveService.firstTimeBox.isEmpty) {
                return languageRoute(firstOpen: true);
              } else {
                return loginRoute();
              }
            }
            return null;
          }),
      GoRoute(
        path: privacyPolicyRoute,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
          path: deleteAccountRoute,
          builder: (context, state) => const DeleteAccountScreenScreen(),
          redirect: (context, state) {
            if (!AccountService.canDeleteAccount) {
              return loginRoute(redirectToDeleteAccount: true);
            }
            return null;
          }),
      GoRoute(
        path: loginRoute(),
        builder: (context, state) {
          Map queryParams = state.uri.queryParameters;
          bool redirectToDeleteAccount =
              queryParams.containsKey('redirectToDeleteAccount') &&
                  queryParams['redirectToDeleteAccount'] == 'true';
          return Login(
            redirectToDeleteAccount: redirectToDeleteAccount,
          );
        },
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const Register(),
      ),
      GoRoute(
        path: languageRoute(),
        builder: (context, state) {
          Map queryParams = state.uri.queryParameters;
          bool isFirstOpen = queryParams.containsKey('firstOpen') &&
              queryParams['firstOpen'] == 'true';

          return ChangeLanguage(isFirstOpen: isFirstOpen);
        },
      ),
    ],
  );
}
