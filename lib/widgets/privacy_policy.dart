import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/widgets/button.dart';

showPrivacyPolicyBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return LayoutBuilder(builder: (context, constraints) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                decoration: kModalBoxDecoration,
                width: constraints.maxWidth > 700 ? 400 : double.infinity,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  24.0,
                  24.0,
                  24.0,
                  MediaQuery.of(context).viewInsets.bottom + 24.0,
                ),
                decoration: kModalBoxDecorationGradient,
                width: constraints.maxWidth > 700 ? 400 : double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'privacy_policy_title'.tr(),
                        style: kTitleTextStyle.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                      ),
                      kFullVSpace,
                      Text(
                        'privacy_policy'.tr(namedArgs: {
                          'name': "Julius Alibrown",
                        }),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      kVSpace24,
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
      });
}

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPrivacyPolicyBottomSheet(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          'privacy_policy_title'.tr(),
          style: kNormalUnderlineTextStyle,
        ),
      ),
    );
  }
}
