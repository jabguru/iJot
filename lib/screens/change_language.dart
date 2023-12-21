import 'dart:developer' as dev;
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/languages.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/custom_scaffold.dart';

class ChangeLanguage extends StatefulWidget {
  final bool isFirstOpen;
  const ChangeLanguage({
    super.key,
    required this.isFirstOpen,
  });
  @override
  ChangeLanguageState createState() => ChangeLanguageState();
}

class ChangeLanguageState extends State<ChangeLanguage> {
  String? _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      if (widget.isFirstOpen) {
        context.setLocale(Locale(context.deviceLocale.languageCode));
      }
    } catch (e) {
      dev.log(e.toString());
    }
    _language = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isFirstOpen,
      child: CustomScaffold(
        title: 'change_language'.tr(),
        shouldShrink: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0.0,
              child: Image.asset(
                'assets/images/watermark.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width:
                            constraints.maxWidth > 700 ? 400 : double.infinity,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo-with-circle.png',
                              height: 115.0,
                            ),
                            kVLargeVSpace,
                            Text(
                              widget.isFirstOpen
                                  ? 'select_language'.tr()
                                  : 'change_language'.tr(),
                              style: kTitleTextStyle,
                            ),
                            kFullVSpace,
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                              child: DropdownButtonFormField<String>(
                                dropdownColor: Colors.white,
                                value: _language,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                                icon: Transform.rotate(
                                    angle: pi / 2,
                                    child: const Icon(Icons.chevron_right)),
                                items: languages
                                    .map(
                                      (lang) => DropdownMenuItem(
                                        value: lang.split(" - ")[0],
                                        child: Text(
                                          lang.split(" - ")[1],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _language = value;
                                    context.setLocale(Locale(value!));
                                  });
                                },
                              ),
                            ),
                            kFullVSpace,
                            CustomButton(
                              buttonColor: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onTap: widget.isFirstOpen
                                  ? () {
                                      HiveService.firstTimeBox.add('opened');
                                      context.go(MyRoutes.loginRoute());
                                    }
                                  : () {
                                      context.go(MyRoutes.homeRoute);
                                    },
                              text: widget.isFirstOpen
                                  ? 'language_continue'.tr()
                                  : 'language_done'.tr(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
