import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static String storageUrl =
      "https://firebasestorage.googleapis.com/v0/b/ijot-1da7a.appspot.com/o/";
  final storage = FirebaseStorage.instance;
  String? url;

  Future uploadFile({
    required String uid,
    required File file,
    required String imageName,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child('$uid/$imageName');

    await fileRef.putFile(file);

    url = await fileRef.getDownloadURL();
  }

  Future deleteFile({required String uid, required String imageName}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child('$uid/$imageName');

    await fileRef.delete();
  }
}
