import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/spaces.dart';

class NoContentWidget extends StatelessWidget {
  const NoContentWidget({
    required this.searchText,
    super.key,
  });
  final String? searchText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/not_found.png',
            height: 177.0,
          ),
        ),
        kHalfVSpace,
        Text(
          searchText != null && searchText!.isNotEmpty
              ? 'no_content_search'.tr(namedArgs: {'searchText': searchText!})
              : 'no_notes_yet'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ],
    );
  }
}
