import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ijot/constants/category.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/services/account.dart';
import 'package:ijot/services/firebase_firestore.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/models/note.dart';
import 'package:ijot/services/note.dart';
import 'package:ijot/widgets/button.dart';

class NoteContainer extends StatefulWidget {
  final Note note;
  final int noteIndex;
  const NoteContainer(
    this.note,
    this.noteIndex, {
    Key? key,
  }) : super(key: key);

  @override
  NoteContainerState createState() => NoteContainerState();
}

class NoteContainerState extends State<NoteContainer> {
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
                        color: kGrey1,
                        fontSize: 12.0,
                      ),
                    ),
                    kVSpace26,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton2(
                          onTap: () => Navigator.pop(context),
                          text: 'delete_cancel'.tr(),
                          textColor: Theme.of(context).primaryColor,
                          buttonColor: kPurple1,
                        ),
                        CustomButton2(
                          onTap: () async {
                            NoteService(
                              hiveService: HiveService(),
                              firebaseFirestoreService:
                                  FirebaseFirestoreService(),
                              loggedInUserId: AccountService.loggedInUserId,
                            ).deleteNote(
                              note: widget.note,
                            );
                            Navigator.pop(context);
                          },
                          text: 'delete'.tr(),
                          textColor: Colors.red,
                          buttonColor: Colors.white,
                          border: Border.all(color: Colors.red),
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
      onTap: () => context.go(
        '/${MyRoutes.noteRoute}/${widget.noteIndex}',
        extra: {
          'note': widget.note,
        },
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
                    color: kBlackColor,
                  )
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: categoryColor(widget.note.category),
                  radius: 10.0,
                ),
                kFullHSpace,
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
                              kHSpace6,
                              GestureDetector(
                                onTap: () => _showDeleteModal(context),
                                child: Image.asset(
                                  'assets/images/delete.png',
                                  height: 16.0,
                                ),
                              ),
                            ],
                          ),
                          kQuarterVSpace,
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
                            widget.note.getCategoryString,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: categoryColor(widget.note.category),
                            ),
                          ),
                          kHalfHSpace,
                          Text(
                            DateFormat(
                              'd MMM y',
                              context.locale.languageCode,
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
