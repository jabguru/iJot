import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:ijot/constants/category.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/methods/hive.dart';
import 'package:ijot/models/note.dart';

class NoteContainer extends StatefulWidget {
  final Note note;
  final int noteIndex;
  const NoteContainer(
    this.note,
    this.noteIndex, {
    Key? key,
  }) : super(key: key);

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
                  'delete_note'.tr(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'delete_note_undone'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 26.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 21.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color(0x4D410E61),
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                            ),
                            child: Text(
                              'delete_cancel'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            HiveMethods().deleteNote(
                              note: widget.note,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 21.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              'delete'.tr(),
                              style: const TextStyle(
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
    bool screenGreaterThan700 = MediaQuery.of(context).size.width > 700;

    return GestureDetector(
      onTap: () => context.beamToNamed(
        '${MyRoutes.noteRoute}/${widget.noteIndex}',
        data: {
          'updateMode': true,
          'note': widget.note,
        },
        beamBackOnPop: true,
        popToNamed: MyRoutes.notesRoute,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
            margin: EdgeInsets.only(
              bottom: screenGreaterThan700 ? 20.0 : 8.0,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            height: 100.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kCircularBorderRadius),
                boxShadow: const [
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
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.note.title!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              GestureDetector(
                                onTap: () => _showDeleteModal(context),
                                child: Image.asset(
                                  'assets/images/delete.png',
                                  height: 16.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            widget.note.details!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
                            widget.note.category!,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: categoryColor(widget.note.category),
                            ),
                          ),
                          Text(
                            DateFormat(
                              'd MMM y',
                              BuildContextEasyLocalizationExtension(context)
                                  .locale
                                  .languageCode,
                            ).format(DateTime.parse(widget.note.dateTime!)),
                            style: const TextStyle(
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
      ),
    );
  }
}
