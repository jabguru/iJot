import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/services/account.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({
    required this.title,
    required this.screenGreaterThan700,
    this.extraWidget,
    super.key,
  });
  final String title;
  final bool screenGreaterThan700;
  final Widget? extraWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            screenGreaterThan700 ? 40.0 : 16.0,
            kIsWeb ? 20.0 : 40.0,
            screenGreaterThan700 ? 40.0 : 16.0,
            8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => kIsWeb ? context.go(MyRoutes.homeRoute) : null,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 38.0,
                  ),
                ),
              ),
              Row(
                children: [
                  if (extraWidget != null && screenGreaterThan700) extraWidget!,
                  if (AccountService.userId != null)
                    Container(
                      height: 35.0,
                      decoration: BoxDecoration(
                        color: kPurple1,
                        borderRadius:
                            BorderRadius.circular(kCircularBorderRadius),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await AccountService.logout();
                          if (context.mounted) {
                            context.go(MyRoutes.loginRoute());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          child: Text(
                            'sign_out'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  kHSpace6,
                  GestureDetector(
                    onTap: () => context.go(
                      MyRoutes.languageRoute(),
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: screenGreaterThan700 ? 40.0 : 16.0,
            right: screenGreaterThan700 ? 40.0 : 16.0,
            bottom: 6.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kPurpleDark1,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!screenGreaterThan700 && extraWidget != null) ...[
                kLargeHSpace,
                Expanded(child: extraWidget!),
              ],
              if (!kIsWeb && Platform.isMacOS && Navigator.canPop(context))
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Tooltip(
                    message: 'close'.tr(),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 36.0,
                        color: kPurpleDark1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
