import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/hive.dart';
import 'package:iJot/screens/change_language.dart';
import 'package:iJot/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomScaffold extends StatefulWidget {
  final Widget child;
  final bool hasTopBars;
  final bool hasBottomBars;
  final String title;
  final bool editMode;
  final Function onTap;
  final bool shouldShrink;
  CustomScaffold({
    this.child,
    this.hasTopBars = true,
    this.hasBottomBars = true,
    @required this.title,
    this.editMode = false,
    this.onTap,
    this.shouldShrink = true,
  });

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool notAnimated = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 200), animateButton);
  }

  animateButton() {
    setState(() {
      notAnimated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              // - bug fixes
              // - automatically sync notes from other devices without signing out and in
              // - multilanguage support
              // - enabled Password reset
              // - privacy policy update
              // - etc like that for playstore
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
                            padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
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
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4D410E61),
                                        borderRadius: BorderRadius.circular(
                                            kCircularBorderRadius),
                                      ),
                                      child: FlatButton(
                                        onPressed: () async {
                                          await userBox.clear();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SplashScreen()));
                                        },
                                        child: Text(
                                          'sign_out'.tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        textColor: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 6.0),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeLanguage())),
                                      child: Icon(Icons.language,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 6.0,
                            ),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: Color(0xFF1D062A),
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                Expanded(child: widget.child),
                SizedBox(height: 8.0),
                widget.hasBottomBars
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              height: 29.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100.0),
                                  topRight: Radius.circular(100.0),
                                ),
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 700),
                            bottom: notAnimated ? 1.0 : 15.0,
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: widget.onTap,
                              child: Container(
                                width: 64.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                    color: Color(0xFF410E61),
                                    borderRadius: BorderRadius.circular(32.0),
                                    boxShadow: [
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
                          )
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
