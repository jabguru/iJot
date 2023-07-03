import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
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
}
