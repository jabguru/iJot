import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/hive.dart';
import 'package:iJot/constants/languages.dart';
import 'package:iJot/screens/login.dart';
import 'package:iJot/widgets/custom_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeLanguage extends StatefulWidget {
  final bool isFirstOpen;
  ChangeLanguage({this.isFirstOpen = false});
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  String _language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasTopBars: false,
      hasBottomBars: false,
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
                padding: EdgeInsets.all(38.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo-with-circle.png',
                      height: 115.0,
                    ),
                    SizedBox(height: 55.0),
                    Text(
                      widget.isFirstOpen
                          ? 'select_language'.tr()
                          : 'change_language'.tr(),
                      style: kTitleTextStyle,
                    ),
                    SizedBox(height: 16.0),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(kCircularBorderRadius),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        value: _language,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        icon: Transform.rotate(
                            angle: pi / 2, child: Icon(Icons.chevron_right)),
                        items: languages
                            .map(
                              (lang) => DropdownMenuItem(
                                child: Text(
                                  lang.split(" - ")[1],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                value: lang.split(" - ")[0],
                              ),
                            )
                            .toList(),
                        onChanged: (String value) {
                          setState(() {
                            _language = value;
                            context.locale = Locale(value);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: widget.isFirstOpen
                          ? () {
                              firstTimeBox.add('opened');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }
                          : () => Navigator.pop(context),
                      child: Container(
                        height: 48.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              BorderRadius.circular(kCircularBorderRadius),
                        ),
                        child: Center(
                          child: Text(
                            widget.isFirstOpen
                                ? 'language_continue'.tr()
                                : 'language_done'.tr(),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
