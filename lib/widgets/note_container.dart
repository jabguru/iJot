import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iJot/constants/category.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/models/note.dart';
import 'package:iJot/screens/single_note.dart';
import 'package:intl/intl.dart';

class NoteContainer extends StatefulWidget {
  final Note note;
  final int noteIndex;
  NoteContainer(this.note, this.noteIndex);

  @override
  _NoteContainerState createState() => _NoteContainerState();
}

class _NoteContainerState extends State<NoteContainer> {
  _showDeleteModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  'Do you want to Delete this Note?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'This action cannot be undone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: 26.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 21.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Color(0x4D410E61),
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final noteBox = Hive.box<Note>('notes');
                            noteBox.deleteAt(widget.noteIndex);
                            deleteNote(widget.note);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 21.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate =
        DateFormat('d MMM y').format(DateTime.parse(widget.note.dateTime));
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleNote(
            updateMode: true,
            note: widget.note,
            noteIndex: widget.noteIndex,
          ),
        ),
      ),
      child: Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          height: 100.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(2, 2),
                  color: Color(0x40000000),
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: categoryColor(widget.note.category),
                radius: 10.0,
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.note.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showDeleteModal(context),
                              child: Image.asset(
                                'assets/images/delete.png',
                                height: 16.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.note.details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.0,
                            height: 1.18,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.note.category,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: categoryColor(widget.note.category),
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
