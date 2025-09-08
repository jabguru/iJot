import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/providers/auth_provider.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/custom_container.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/progress.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class DeleteAccountScreenScreen extends StatefulWidget {
  const DeleteAccountScreenScreen({super.key});

  @override
  State<DeleteAccountScreenScreen> createState() =>
      _DeleteAccountScreenScreenState();
}

class _DeleteAccountScreenScreenState extends State<DeleteAccountScreenScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'delete_account'.tr(),
      hasTopBars: true,
      mainContentPadding: true,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: ref.watch(authNotifierProvider),
            color: Theme.of(context).primaryColor,
            progressIndicator: circularProgress(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'delete_account_confirmation'.tr(),
                          style: kTitleTextStyle,
                        ),
                        kHalfVSpace,
                        Text(
                          'delete_account_confirmation_details'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: kGrey1),
                        ),
                        kLargeVSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton2(
                              onTap: () => Navigator.pop(context),
                              text: 'delete_cancel'.tr(),
                              textColor: Theme.of(context).primaryColor,
                              buttonColor: kPurple1,
                            ),
                            kFullHSpace,
                            CustomButton2(
                              onTap:
                                  ref
                                      .read(authNotifierProvider.notifier)
                                      .deleteAccount,
                              text: 'delete'.tr(),
                              textColor: Colors.red,
                              buttonColor: Colors.white,
                              border: Border.all(color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
