import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ijot/widgets/notes/notes_list.dart';
import 'package:ijot/widgets/search_widget.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  NotesState createState() => NotesState();
}

class NotesState extends State<Notes> {
  final ScrollController _notesScrollController = ScrollController();
  String? _searchText;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        hasBottomBars: true,
        hasTopBars: true,
        title: 'notes'.tr(),
        extraTopBarWidget: SearchWidget(
          onChanged: (String text) {
            setState(() {
              _searchText = text;
            });
          },
        ),
        scrollController: _notesScrollController,
        child: NotesListWidget(
          scrollController: _notesScrollController,
          searchText: _searchText,
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
