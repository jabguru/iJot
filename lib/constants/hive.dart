import 'package:hive/hive.dart';
import 'package:iJot/models/note.dart';

final notesBox = Hive.box<Note>('notes');
var userBox = Hive.box('user');
var firstTimeBox = Hive.box('firstOpen');
