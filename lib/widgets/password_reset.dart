import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/widgets/progress.dart';
import 'package:iJot/widgets/snackbar.dart';

showForgotPasswordBottomSheet(BuildContext context) {
  final _forgotPassFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _resetEmail;

  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24.0,
                24.0,
                24.0,
                MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                // gradient: kLinearGradient,
                color: Color(0xFFEEAAC2).withOpacity(0.85),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'reset_password_title'.tr(),
                    style: kTitleTextStyle,
                  ),
                  SizedBox(height: 16.0),
                  Form(
                    key: _forgotPassFormKey,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(kCircularBorderRadius),
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return 'validation_email'.tr();
                          } else if (!val.trim().contains(RegExp(
                              r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
                              caseSensitive: false))) {
                            return 'validation_email_2'.tr();
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _resetEmail = value,
                        style: kInputTextStyle,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'email'.tr(),
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _isLoading
                      ? circularProgress()
                      : Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  final form = _forgotPassFormKey.currentState;

                                  if (form.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    form.save();

                                    try {
                                      await fireBaseAuth.sendPasswordResetEmail(
                                          email: _resetEmail);
                                      Navigator.pop(context);
                                      showSuccessSnackbar(context,
                                          message:
                                              "password_reset_successful".tr());
                                    } catch (e) {
                                      showErrorSnackbar(context,
                                          message: e.message);
                                    }

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        kCircularBorderRadius),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'reset'.tr(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        kCircularBorderRadius),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'delete_cancel'.tr(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          },
        );
      });
}
