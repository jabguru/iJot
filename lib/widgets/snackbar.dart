import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// class ErrorContainer extends StatelessWidget {
//   const ErrorContainer({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 240.0,
//       decoration: BoxDecoration(
//         color: Color(0xFF444444),
//         borderRadius: BorderRadius.circular(kCircularBorderRadius),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 43.0, vertical: 15.0),
//       child: Center(
//         child: Text(
//           'Note Must Have a Title',
//           style: TextStyle(color: Colors.white, fontSize: 16.0),
//         ),
//       ),
//     );
//   }
// }

void showSuccessSnackbar(BuildContext context, {String title, String message}) {
  Flushbar(
    margin: EdgeInsets.all(20.0),
    padding: EdgeInsets.all(20.0),
    borderRadius: 15.0,
    title: title,
    message: message,
    backgroundColor: Theme.of(context).accentColor,
    icon: Icon(
      Icons.check_circle,
      color: Colors.green,
    ),
    duration: Duration(seconds: 2),
  )..show(context);
}

void showErrorSnackbar(BuildContext context, {String title, String message}) {
  Flushbar(
    margin: EdgeInsets.all(20.0),
    padding: EdgeInsets.all(20.0),
    borderRadius: 15.0,
    message: message,
    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
    icon: Icon(
      Icons.warning,
      size: 28.0,
      color: Colors.red,
    ),
    duration: Duration(seconds: 3),
  )..show(context);
}
