import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/supported_locales.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class TestHelper {
  static Widget createScreen(Widget screen) {
    return EasyLocalization(
      path: 'assets/translations',
      supportedLocales: supportedLocales,
      child: Builder(
        builder: (context) => MaterialApp(
          home: screen,
          // localizationsDelegates: context.localizationDelegates,
          // supportedLocales: context.supportedLocales,
          // locale: context.locale,
        ),
      ),
    );
  }

  static Widget createScreenWithGoRouter(GoRouter router) {
    return EasyLocalization(
      path: 'assets/translations',
      supportedLocales: supportedLocales,
      child: Builder(
        builder: (context) => MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
  }

  static setUpAll() async {
    SharedPreferences.setMockInitialValues({});
    EasyLocalization.logger.enableLevels = [];
    await EasyLocalization.ensureInitialized();
    await initializeDateFormatting();
  }

  static void ignoreOverflowErrors(
    FlutterErrorDetails details, {
    bool forceReport = false,
  }) {
    bool ifIsOverflowError = false;
    bool isUnableToLoadAsset = false;

    // Detect overflow error.
    var exception = details.exception;
    if (exception is FlutterError) {
      ifIsOverflowError = !exception.diagnostics.any(
        (e) => e.value.toString().startsWith("A RenderFlex overflowed by"),
      );
      isUnableToLoadAsset = !exception.diagnostics.any(
        (e) => e.value.toString().startsWith("Unable to load asset"),
      );
    }

    // Ignore if is overflow error.
    if (ifIsOverflowError || isUnableToLoadAsset) {
      // debugPrint('Ignored Error');
    } else {
      FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    }
  }
}
