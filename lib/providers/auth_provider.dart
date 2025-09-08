import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/services/account.dart';
import 'package:ijot/widgets/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool _redirectToDeleteAccount = false;
  BuildContext? _context;

  @override
  bool build() {
    return false;
  }

  void init({
    required BuildContext context,
    bool isLogin = false,
    bool redirectToDeleteAccount = false,
  }) {
    _redirectToDeleteAccount = redirectToDeleteAccount;
    _context = context;
    if (isLogin) {
      unawaited(
        googleSignIn.initialize().then((_) {
          googleSignIn.authenticationEvents
              .listen(_handleAuthenticationEvent)
              .onError(_handleAuthenticationError);
        }),
      );
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = true;
    try {
      final fireBaseAuth = FirebaseAuth.instance;
      await fireBaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User currentUser = fireBaseAuth.currentUser!;
      String userId = currentUser.uid;

      await AccountService.login(userId);

      if (_context?.mounted ?? false) {
        _context!.go(MyRoutes.homeRoute);
      }
    } on FirebaseException catch (e) {
      if (_context?.mounted ?? false) {
        showErrorSnackbar(_context!, message: e.message);
      }
    }

    state = false;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = true;

    try {
      final fireBaseAuth = FirebaseAuth.instance;
      await fireBaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User currentUser = fireBaseAuth.currentUser!;
      String userId = currentUser.uid;

      await AccountService.login(userId);

      state = false;
      _naviagateToScreenOnSuccess();
    } on FirebaseException catch (e) {
      state = false;
      if (_context?.mounted ?? false) {
        showErrorSnackbar(_context!, message: e.message);
      }
    }
  }

  void signInWithGoogle() {
    try {
      googleSignIn.authenticate();
    } catch (e) {
      // print('Error Signing in: $e');
      if (_context?.mounted ?? false) {
        showErrorSnackbar(
          _context!,
          message: 'Unable to Sign in with Google, try again.',
        );
      }
    }
  }

  Future<void> deleteAccount() async {
    state = true;
    bool deleted = await AccountService.deleteAccount();
    state = false;

    if (_context?.mounted ?? false) {
      _context!.go(MyRoutes.loginRoute(redirectToDeleteAccount: !deleted));
      if (deleted) {
        showSuccessSnackbar(
          _context!,
          message: 'delete_account_sucessful'.tr(),
        );
      } else {
        showErrorSnackbar(_context!, message: 'delete_account_error'.tr());
      }
    }
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    state = true;
    final GoogleSignInAccount? currentUser = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (currentUser != null) {
      String userId = currentUser.id;

      await AccountService.login(userId);

      state = false;
      _naviagateToScreenOnSuccess();
    }
  }

  void _handleAuthenticationError(dynamic error) {
    // print('Error Signing in: $error');
    if (_context?.mounted ?? false) {
      showErrorSnackbar(
        _context!,
        message: 'Unable to Sign in with Google, try again.',
      );
    }
  }

  void _naviagateToScreenOnSuccess() {
    if (_context?.mounted ?? false) {
      _context!.go(
        _redirectToDeleteAccount
            ? MyRoutes.deleteAccountRoute
            : MyRoutes.homeRoute,
      );
    }
  }
}
