import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/widgets/button.dart';

showPrivacyPolicyBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                24.0,
                24.0,
                24.0,
                MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                gradient: kLinearGradient,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'privacy_policy_title'.tr(),
                      style: kTitleTextStyle,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'privacy_policy'.tr(namedArgs: {
                        'name': "Julius Alibrown",
                      }),
                      style: TextStyle(
                        color: Color(0xFF1D062A),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    CustomButton(
                      buttonColor: Theme.of(context).primaryColor,
                      text: "language_done".tr(),
                      textColor: Colors.white,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}
