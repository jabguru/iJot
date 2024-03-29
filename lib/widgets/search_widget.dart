import 'dart:io';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({required this.onChanged, super.key});
  final ValueChanged<String> onChanged;

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  double getPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width > 1080) {
      return 300.0;
    } else if (width > 700) {
      return 100.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getPadding(context)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kCircularBorderRadius),
        child: SizedBox(
          height: 35.0,
          child: AnimatedSearchBar(
            cursorColor: kPrimaryColor,
            height: 35.0,
            onChanged: onChanged,
            searchDecoration: kTextFieldDecoration.copyWith(
              hintText: 'search'.tr(),
              contentPadding: !_isMobile
                  ? const EdgeInsets.only(
                      top: 0.0,
                      bottom: 20.0,
                      left: 20.0,
                      right: 20.0,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
