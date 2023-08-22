import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/widgets/custom_container.dart';
import 'package:ijot/widgets/custom_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'privacy_policy_title'.tr(),
      hasTopBars: true,
      child: CustomContainer(
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
