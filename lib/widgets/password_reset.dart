import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/firebase.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/progress.dart';
import 'package:ijot/widgets/snackbar.dart';

showForgotPasswordBottomSheet(BuildContext context) {
  final forgotPassFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? resetEmail;

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return LayoutBuilder(builder: (context, constraints) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: 200.0,
                    decoration: kModalBoxDecoration,
                    width: constraints.maxWidth > 700 ? 400 : double.infinity,
                  ),
                  Container(
                    height: 200.0,
                    padding: EdgeInsets.fromLTRB(
                      24.0,
                      24.0,
                      24.0,
                      MediaQuery.of(context).viewInsets.bottom + 24.0,
                    ),
                    width: constraints.maxWidth > 700 ? 400 : double.infinity,
                    decoration: kModalBoxDecorationGradient,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'reset_password_title'.tr(),
                              style: kTitleTextStyle,
                            ),
                            kFullVSpace,
                            Form(
                              key: forgotPassFormKey,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    kCircularBorderRadius),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {
                                      return 'validation_email'.tr();
                                    } else if (!val.trim().contains(RegExp(
                                        r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
                                        caseSensitive: false))) {
                                      return 'validation_email_2'.tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => resetEmail = value,
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
                            kHalfVSpace,
                            isLoading
                                ? circularProgress()
                                : Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomButton(
                                          buttonColor:
                                              Theme.of(context).primaryColor,
                                          text: 'reset'.tr(),
                                          textColor: Colors.white,
                                          onTap: () async {
                                            final form =
                                                forgotPassFormKey.currentState!;

                                            if (form.validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              form.save();

                                              try {
                                                await fireBaseAuth
                                                    .sendPasswordResetEmail(
                                                        email: resetEmail!);
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  showSuccessSnackbar(context,
                                                      message:
                                                          "password_reset_successful"
                                                              .tr());
                                                }
                                              } on FirebaseException catch (e) {
                                                showErrorSnackbar(context,
                                                    message: e.message);
                                              }

                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      kHalfHSpace,
                                      Expanded(
                                        child: CustomButton(
                                          buttonColor: Colors.white,
                                          text: 'delete_cancel'.tr(),
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          onTap: () => Navigator.pop(context),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
          },
        );
      });
}
