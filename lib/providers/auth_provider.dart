import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ijot/services/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  @override
  AsyncValue<bool> build() {
    return AsyncValue.data(false);
  }

  void init({
    required BuildContext context,
    bool isLogin = false,
    bool redirectToDeleteAccount = false,
  }) {
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
    state = const AsyncValue.loading();
    try {
      final fireBaseAuth = FirebaseAuth.instance;
      await fireBaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User currentUser = fireBaseAuth.currentUser!;
      String userId = currentUser.uid;

      await AccountService.login(userId);
    } on FirebaseException catch (e) {
      state = AsyncValue.error(
        e.message ?? 'An error occurred, please try again.',
        StackTrace.current,
      );
    }

    state = const AsyncValue.data(true);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      final fireBaseAuth = FirebaseAuth.instance;
      await fireBaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User currentUser = fireBaseAuth.currentUser!;
      String userId = currentUser.uid;

      await AccountService.login(userId);
    } on FirebaseException catch (e) {
      state = AsyncValue.error(
        e.message ?? 'An error occurred, please try again.',
        StackTrace.current,
      );
    }

    state = const AsyncValue.data(true);
  }

  void signInWithGoogle() {
    try {
      googleSignIn.authenticate();
    } catch (e) {
      // print('Error Signing in: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();

    bool deleted = await AccountService.deleteAccount();
    state = AsyncValue.data(deleted);
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    state = const AsyncValue.loading();

    final GoogleSignInAccount? currentUser = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (currentUser != null) {
      String userId = currentUser.id;

      await AccountService.login(userId);

      state = const AsyncValue.data(true);
    }
  }

  void _handleAuthenticationError(dynamic error) {
    // print('Error Signing in: $error');
    state = AsyncValue.error(
      'Unable to Sign in with Google, try again.',
      StackTrace.current,
    );
  }
}
