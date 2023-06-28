import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({required this.onChanged, super.key});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 700 ? 300.0 : 200,
        height: 35.0,
        child: AnimatedSearchBar(
          cursorColor: kPrimaryColor,
          height: 35.0,
          onChanged: onChanged,
          searchDecoration: kTextFieldDecoration.copyWith(
            hintText: 'search'.tr(),
            contentPadding: const EdgeInsets.only(
              top: 0.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
