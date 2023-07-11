import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends Equatable {
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

  @HiveField(6)
  final String? detailsJSON;

  const Note({
    required this.id,
    this.title,
    this.details,
    this.category,
    this.dateTime,
    this.ownerId,
    this.detailsJSON,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    return Note(
      id: doc['id'],
      title: doc['title'],
      details: doc['details'],
      category: doc['category'],
      dateTime: (doc['dateTime'] as Timestamp).toDate().toString(),
      ownerId: doc['ownerId'],
      detailsJSON: doc.data().toString().contains('detailsJSON')
          ? doc['detailsJSON']
          : null,
    );
  }

  String get getCategoryString {
    switch (category) {
      case 'Uncategorized':
        return 'note_cat_uncategorized'.tr();
      case 'Study':
        return 'note_cat_study'.tr();
      case 'Personal':
        return 'note_cat_personal'.tr();
      case 'Work':
        return 'note_cat_work'.tr();
      case 'Todo':
        return 'note_cat_todo'.tr();
      default:
        return 'note_cat_uncategorized'.tr();
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        details,
        category,
        dateTime,
        ownerId,
        detailsJSON,
      ];
}
