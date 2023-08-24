import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ijot/constants/firebase.dart';
import 'package:ijot/constants/hive.dart';

class AccountService {
  static String? get userId => userBox.get('userId');
  static User? get currentUser => fireBaseAuth.currentUser;
  static bool get canDeleteAccount => userId != null && currentUser != null;
  static logout() async {
    await userBox.clear();
    await fireBaseAuth.signOut();
  }

  static Future<bool> deleteAccount() async {
    try {
      if (canDeleteAccount) {
        // delete all notes
        // from firestore
        await notesRef.doc(userId).delete();
        // from localdb
        await notesBox.clear();

        // delete account
        await currentUser!.delete();

        // logout
        await logout();
        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
