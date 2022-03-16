// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/firebase.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/models/note.dart';

class FirebaseMethods {
  Future syncNote(Note note) async {
    try {
      notesRef.doc(loggedInUserId).collection('userNotes').doc(note.id).set({
        'id': note.id,
        'title': note.title,
        'details': note.details,
        'category': note.category,
        'dateTime': DateTime.parse(note.dateTime!),
        'ownerId': note.ownerId,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateNote(Note note) {
    try {
      notesRef.doc(loggedInUserId).collection('userNotes').doc(note.id).update(
        {
          'title': note.title,
          'details': note.details,
          'category': note.category,
          'dateTime': DateTime.parse(note.dateTime!),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteNote(Note note) {
    try {
      notesRef
          .doc(loggedInUserId)
          .collection('userNotes')
          .doc(note.id)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  cloudToLocal() async {
    try {
      QuerySnapshot snapshot = await notesRef
          .doc(loggedInUserId)
          .collection('userNotes')
          .orderBy('dateTime')
          .get();

      for (var doc in snapshot.docs) {
        bool isContained = false;
        Note cloudNote = Note.fromDocument(doc);
        for (var i = 0; i < notesBox.length; i++) {
          if (loggedInUserId == notesBox.getAt(i)!.ownerId) {
            if (cloudNote.id == notesBox.getAt(i)!.id) {
              isContained = true;
            }
          }
        }
        if (!isContained) notesBox.add(cloudNote);
      }
    } catch (e) {
      print(e.toString);
    }
  }

  deleteNotesDeletedFromOtherDevices() async {
    QuerySnapshot snapshot = await notesRef
        .doc(loggedInUserId)
        .collection('userNotes')
        .orderBy('dateTime')
        .get();

    List<Note> cloudNotes = snapshot.docs
        .map((QueryDocumentSnapshot doc) => Note.fromDocument(doc))
        .toList();

    for (var i = 0; i < notesBox.length; i++) {
      if (loggedInUserId == notesBox.getAt(i)!.ownerId) {
        Iterable<Note> containedNotes =
            cloudNotes.where((Note note) => note.id == notesBox.getAt(i)!.id);
        if (containedNotes.isEmpty) {
          notesBox.deleteAt(i);
        }
      }
    }
  }
}
