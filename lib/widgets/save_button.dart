import 'package:flutter/material.dart';
import 'package:ijot/constants/colors.dart';

class SaveButton extends StatelessWidget {
  final bool editMode;
  final VoidCallback? onTap;
  final bool isSmall;

  const SaveButton({
    super.key,
    required this.editMode,
    this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: isSmall ? 48.0 : 64.0,
          height: isSmall ? 48.0 : 64.0,
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
            editMode ? Icons.check : Icons.add,
            color: Colors.white,
            size: isSmall ? 24.0 : 30.0,
          ),
        ),
      ),
    );
  }
}
