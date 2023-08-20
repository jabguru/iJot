import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/widgets/custom_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'privacy_policy_title'.tr(),
      hasTopBars: true,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(2, 2),
              color: kBlackColor,
            ),
          ],
        ),
        child: TextFormField(
          initialValue: 'privacy_policy'.tr(namedArgs: {
            'name': "Julius Alibrown",
          }),
          expands: true,
          maxLines: null,
          minLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: 'privacy_policy_title'.tr(),
            hintStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: kPink1,
            ),
          ),
          readOnly: true,
        ),
      ),
    );
  }
}
