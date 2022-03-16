import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/constants/routes.dart';

class CustomScaffold extends StatefulWidget {
  final Widget? child;
  final bool hasTopBars;
  final bool hasBottomBars;
  final String title;
  final bool editMode;
  final Function? onTap;
  final bool shouldShrink;
  const CustomScaffold({
    Key? key,
    this.child,
    this.hasTopBars = true,
    this.hasBottomBars = true,
    required this.title,
    this.editMode = false,
    this.onTap,
    this.shouldShrink = true,
  }) : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool notAnimated = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), animateButton);
  }

  animateButton() {
    if (mounted) {
      setState(() {
        notAnimated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool screenGreaterThan700 = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      resizeToAvoidBottomInset: widget.shouldShrink,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: kLinearGradient,
              // TODO: an avenue for snapping and adding to notes
              // TODO: UPDATE ALL NOTES WITH CURRENT LANGUAGE CATEGORY AFTER LANGUAGE CHANGE
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.hasTopBars
                    ? Column(
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
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 38.0,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0x4D410E61),
                                        borderRadius: BorderRadius.circular(
                                            kCircularBorderRadius),
                                      ),
                                      child: TextButton(
                                        onPressed: () async {
                                          await userBox.clear();
                                          context.vxNav.replace(
                                            Uri.parse(MyRoutes.loginRoute),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 5.0,
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
                                    const SizedBox(width: 6.0),
                                    GestureDetector(
                                      onTap: () => context.vxNav.push(
                                          Uri.parse(MyRoutes.languageRoute)),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Icon(Icons.language,
                                            color:
                                                Theme.of(context).primaryColor),
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
                                  widget.title,
                                  style: const TextStyle(
                                    color: Color(0xFF1D062A),
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (Platform.isMacOS &&
                                    Navigator.canPop(context))
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Tooltip(
                                      // TODO: RETRANSLATE JSON FILES
                                      message: 'close'.tr(),
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(
                                          Icons.close,
                                          size: 36.0,
                                          color: Color(0xFF1D062A),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Scrollbar(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenGreaterThan700 ? 40.0 : 0.0),
                      child: widget.child,
                    ),
                    thickness: screenGreaterThan700 ? 8.0 : 0.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                widget.hasBottomBars
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenGreaterThan700 ? 40.0 : 0.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                height: 29.0,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100.0),
                                    topRight: Radius.circular(100.0),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 700),
                              bottom: notAnimated ? 1.0 : 15.0,
                              curve: Curves.easeInOut,
                              child: GestureDetector(
                                onTap: widget.onTap as void Function()?,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    width: 64.0,
                                    height: 64.0,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x4D410E61),
                                            blurRadius: 8.0,
                                            offset: Offset(0, 4),
                                          )
                                        ]),
                                    child: Icon(
                                      widget.editMode ? Icons.check : Icons.add,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
