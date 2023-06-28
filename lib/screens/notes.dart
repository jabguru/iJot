import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ijot/widgets/notes/notes_list.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  NotesState createState() => NotesState();
}

class NotesState extends State<Notes> {
  final ScrollController _notesScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        title: 'notes'.tr(),
        scrollController: _notesScrollController,
        child: NotesListWidget(
          scrollController: _notesScrollController,
        ),
        onTap: () {
          context.beamToNamed(
            MyRoutes.noteRoute,
            beamBackOnPop: true,
          );
        },
      ),
    );
  }
}
