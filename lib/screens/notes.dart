import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/services/account.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/notes/notes_list.dart';
import 'package:ijot/widgets/search_widget.dart';
import 'package:ijot/widgets/sort_note_widget.dart';
import 'package:upgrader/upgrader.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: UpgradeAlert(
        dialogStyle:
            !kIsWeb && Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
        upgrader: Upgrader(
          messages: UpgraderMessages(code: context.locale.languageCode),
        ),
        child: NotesScreenContent(
          loggedInUserId: AccountService.loggedInUserId,
        ),
      ),
    );
  }
}

class NotesScreenContent extends StatefulWidget {
  final String? loggedInUserId;
  const NotesScreenContent({super.key, required this.loggedInUserId});

  @override
  State<NotesScreenContent> createState() => _NotesScreenContentState();
}

class _NotesScreenContentState extends State<NotesScreenContent> {
  final ScrollController _notesScrollController = ScrollController();
  String? _searchText;
  String _category = 'All';

  void _onSelected(dynamic value) {
    setState(() {
      _category = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasBottomBars: true,
      hasTopBars: true,
      shouldShrink: false,
      title: 'notes'.tr(),
      extraTopBarWidget: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SearchWidget(
              onChanged: (String text) {
                setState(() {
                  _searchText = text;
                });
              },
            ),
          ),
          kHalfHSpace,
          SortNoteWidget(onSelected: _onSelected, value: _category),
        ],
      ),
      scrollController: _notesScrollController,
      child: NotesListWidget(
        scrollController: _notesScrollController,
        searchText: _searchText,
        category: _category,
        loggedInUserId: widget.loggedInUserId,
      ),
      onTap: () {
        context.go('/${MyRoutes.noteRoute}');
      },
    );
  }
}
