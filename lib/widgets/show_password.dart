import 'package:flutter/material.dart';

class ShowPasswordWidget extends StatelessWidget {
  final VoidCallback onTap;
  const ShowPasswordWidget({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Image.asset(
            'assets/images/show_password.png',
            width: 24.0,
            height: 24.0,
          ),
        ),
      ),
    );
  }
}
