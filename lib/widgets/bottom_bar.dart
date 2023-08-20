import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({
    required this.screenGreaterThan700,
    required this.editMode,
    required this.onTap,
    super.key,
  });
  final bool screenGreaterThan700;
  final bool editMode;
  final VoidCallback? onTap;

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
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
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.screenGreaterThan700 ? 40.0 : 0.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
              onTap: widget.onTap,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(32.0),
                      boxShadow: const [
                        BoxShadow(
                          color: kPurple1,
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
    );
  }
}
