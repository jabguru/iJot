import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:iJot/models/note.dart';

final fireBaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String loggedInUserId;
var userBox = Hive.box('user');
final notesRef = FirebaseFirestore.instance.collection('notes');
final notesBox = Hive.box<Note>('notes');

syncNote(Note note) {
  try {
    notesRef.doc(loggedInUserId).collection('userNotes').doc(note.id).set({
      'id': note.id,
      'title': note.title,
      'details': note.details,
      'category': note.category,
      'dateTime': DateTime.parse(note.dateTime),
      'ownerId': note.ownerId,
    });
  } catch (e) {
    print(e.toString());
  }
}

updateNote(Note note) {
  try {
    notesRef.doc(loggedInUserId).collection('userNotes').doc(note.id).update({
      'title': note.title,
      'details': note.details,
      'category': note.category,
      'dateTime': DateTime.parse(note.dateTime),
    });
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

    snapshot.docs.forEach((doc) {
      bool isContained = false;
      Note cloudNote = Note.fromDocument(doc);
      for (var i = 0; i < notesBox.length; i++) {
        if (loggedInUserId == notesBox.getAt(i).ownerId) {
          if (cloudNote.id == notesBox.getAt(i).id) {
            isContained = true;
          }
        }
      }
      if (!isContained) notesBox.add(cloudNote);
    });
  } catch (e) {
    print(e.toString);
  }
}
