import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijot/models/note.dart';

class FirebaseFirestoreService {
  final notesRef = FirebaseFirestore.instance.collection('notes');

  Future syncNote({required Note note, required String userId}) async {
    try {
      notesRef.doc(userId).collection('userNotes').doc(note.id).set({
        'id': note.id,
        'title': note.title,
        'details': note.details,
        'category': note.category,
        'dateTime': DateTime.parse(note.dateTime!),
        'detailsJSON': note.detailsJSON,
        'ownerId': note.ownerId,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void updateNote({required Note note, required String userId}) {
    try {
      notesRef.doc(userId).collection('userNotes').doc(note.id).update({
        'title': note.title,
        'details': note.details,
        'category': note.category,
        'dateTime': DateTime.parse(note.dateTime!),
        'detailsJSON': note.detailsJSON,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void deleteNote({required Note note, required String userId}) {
    try {
      notesRef.doc(userId).collection('userNotes').doc(note.id).get().then((
        doc,
      ) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteDocument(String? userId) async {
    await notesRef.doc(userId).delete();
  }

  Future<List> getUserNotes(String userId) async {
    QuerySnapshot snapshot =
        await notesRef
            .doc(userId)
            .collection('userNotes')
            .orderBy('dateTime')
            .get();

    return snapshot.docs;
  }
}
