import 'package:flutter/material.dart';

import 'package:ijot/constants/constants.dart';
import 'package:ijot/widgets/bottom_bar.dart';
import 'package:ijot/widgets/top_bar.dart';

class CustomScaffold extends StatefulWidget {
  final Widget? child;
  final bool hasTopBars;
  final bool hasBottomBars;
  final String title;
  final bool editMode;
  final VoidCallback? onTap;
  final bool shouldShrink;
  final ScrollController? scrollController;
  final Widget? extraTopBarWidget;

  const CustomScaffold({
    Key? key,
    this.child,
    this.hasTopBars = false,
    this.hasBottomBars = false,
    required this.title,
    this.editMode = false,
    this.onTap,
    this.shouldShrink = true,
    this.scrollController,
    this.extraTopBarWidget,
  }) : super(key: key);

  @override
  CustomScaffoldState createState() => CustomScaffoldState();
}

class CustomScaffoldState extends State<CustomScaffold> {
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
              // TODO: ADD TEXT DECORATION BOLD, UNDERLINE, ETC
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.hasTopBars)
                  TopBarWidget(
                    title: widget.title,
                    screenGreaterThan700: screenGreaterThan700,
                    extraWidget: widget.extraTopBarWidget,
                  ),
                Expanded(
                  child: Scrollbar(
                    controller: widget.scrollController,
                    thickness: screenGreaterThan700 ? 8.0 : 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenGreaterThan700 ? 40.0 : 0.0),
                      child: widget.child,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                if (widget.hasBottomBars)
                  BottomBarWidget(
                    screenGreaterThan700: screenGreaterThan700,
                    editMode: widget.editMode,
                    onTap: widget.onTap,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
