import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/constants/hive.dart';
import 'package:iJot/screens/login.dart';
import 'package:iJot/screens/notes.dart';
import 'package:iJot/widgets/custom_scaffold.dart';
import 'package:iJot/widgets/privacy_policy.dart';
import 'package:iJot/widgets/progress.dart';
import 'package:iJot/widgets/snackbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _hidePassword = true;
  String _emailInput;
  String _passwordInput;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleSignUp() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      print(_emailInput + _passwordInput);

      try {
        final newUser = await fireBaseAuth.createUserWithEmailAndPassword(
            email: _emailInput.trim(), password: _passwordInput.trim());
        if (newUser != null) {
          final User currentUser = fireBaseAuth.currentUser;
          String userId = currentUser.uid;

          loggedInUserId = userId;

          userBox.put('userId', userId);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Notes()));
        }
      } catch (e) {
        showErrorSnackbar(context, message: e.message);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'register'.tr(),
      hasTopBars: false,
      hasBottomBars: false,
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        color: Theme.of(context).primaryColor,
        progressIndicator: circularProgress(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0.0,
              child: Image.asset(
                'assets/images/watermark.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(38.0),
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo-with-circle.png',
                          height: 115.0),
                      SizedBox(height: 55.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ClipRRect(
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
                                onSaved: (value) => _emailInput = value,
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
                            SizedBox(height: 8.0),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                              child: TextFormField(
                                validator: (val) {
                                  if (val.trim().isEmpty) {
                                    return 'validation_password'.tr();
                                  } else if (val.trim().length < 6) {
                                    return 'validation_password_2'.tr();
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) => _passwordInput = value,
                                style: kInputTextStyle,
                                decoration: InputDecoration(
                                  hintText: 'password'.tr(),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  errorStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _hidePassword = !_hidePassword;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Image.asset(
                                        'assets/images/show_password.png',
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: _hidePassword,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            GestureDetector(
                              onTap: handleSignUp,
                              child: Container(
                                height: 48.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      kCircularBorderRadius),
                                ),
                                child: Center(
                                  child: Text(
                                    'sign_up'.tr(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'already_have_an_account'.tr(),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontFamily: 'Cabin',
                              ),
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: 'sign_in'.tr(),
                              style: kNormalUnderlineTextStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07),
                      GestureDetector(
                        onTap: () => showPrivacyPolicyBottomSheet(context),
                        child: Text(
                          'privacy_policy_title'.tr(),
                          style: kNormalUnderlineTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
