import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/screens/splash_screen.dart';

class CustomScaffold extends StatefulWidget {
  final Widget child;
  final bool hasBars;
  final String title;
  final bool editMode;
  final Function onTap;
  final bool shouldShrink;
  CustomScaffold({
    this.child,
    this.hasBars = true,
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
              gradient: LinearGradient(
                colors: [
                  Color(0x80EEAAC2),
                  Color(0x80410E61),
                  //- bug fixes
                  //- multilanguage support
                  //- etc like that for playstore
                  // TODO: an avenue for snapping and adding to notes
                  // TODO: add localization
                  //TODO: MAKE FIXES FROM REVIEWS
                  //TODO: automatically updating notes when logged in, incase i write a note in another device i wont need to log in and out of my own device. this would be done on load (main.dart or home)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.hasBars
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SplashScreen()));
                                    },
                                    child: Text('Sign Out',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        )),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.0),
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
                widget.hasBars
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              height: 20.0,
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
                            duration: Duration(seconds: 1),
                            bottom: notAnimated ? 1.0 : 6.0,
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
