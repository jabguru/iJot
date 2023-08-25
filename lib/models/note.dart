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

  static String? _getDetaisJson(var doc) {
    if (doc is Map) {
      if (doc.containsKey('detailsJSON')) {
        return doc['detailsJSON'];
      }
    } else {
      if (doc.data().toString().contains('detailsJSON')) {
        return doc['detailsJSON'];
      }
    }
    return null;
  }

  factory Note.fromDocument(var doc) {
    return Note(
      id: doc['id'],
      title: doc['title'],
      details: doc['details'],
      category: doc['category'],
      dateTime: (doc['dateTime'] as Timestamp).toDate().toString(),
      ownerId: doc['ownerId'],
      detailsJSON: _getDetaisJson(doc),
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

  Note copyWith({
    String? title,
    String? details,
    String? category,
    String? dateTime,
    String? detailsJSON,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      details: details ?? this.details,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      ownerId: ownerId,
      detailsJSON: detailsJSON ?? this.detailsJSON,
    );
  }
}
