import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/services/note.dart';

class AccountService {
  static HiveService hiveService = HiveService();
  static final fireBaseAuth = FirebaseAuth.instance;

  static String? get loggedInUserId => hiveService.userBox.get('userId');

  static User? get currentUser => fireBaseAuth.currentUser;
  static bool get canDeleteAccount =>
      loggedInUserId != null && currentUser != null;

  static Future<void> logout() async {
    await hiveService.userBox.clear();
    await fireBaseAuth.signOut();
  }

  static Future<void> login(String userId) async {
    await hiveService.userBox.put('userId', userId);
    FirebaseFirestoreService firebaseFirestoreService =
        FirebaseFirestoreService();
    NoteService noteService = NoteService(
      hiveService: hiveService,
      firebaseFirestoreService: firebaseFirestoreService,
      loggedInUserId: userId,
    );
    await noteService.cloudToLocal();
    await noteService.checkForUserItems();
  }

  static Future<bool> deleteAccount() async {
    try {
      if (canDeleteAccount) {
        // delete all notes
        // from firestore
        await FirebaseFirestoreService().deleteDocument(loggedInUserId);
        // from localdb
        await HiveService().clearUserBox();

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
