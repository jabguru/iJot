import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? details;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final String? dateTime;

  @HiveField(5)
  final String? ownerId;

  Note({
    required this.id,
    this.title,
    this.details,
    this.category,
    this.dateTime,
    this.ownerId,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    return Note(
      id: doc['id'],
      title: doc['title'],
      details: doc['details'],
      category: doc['category'],
      dateTime: (doc['dateTime'] as Timestamp).toDate().toString(),
      ownerId: doc['ownerId'],
    );
  }
}
