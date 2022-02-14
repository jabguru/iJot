import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/constants/hive.dart';
import 'package:iJot/constants/routes.dart';
import 'package:iJot/methods/firebase.dart';
import 'package:iJot/methods/hive.dart';
import 'package:iJot/widgets/button.dart';
import 'package:iJot/widgets/custom_scaffold.dart';
import 'package:iJot/widgets/password_reset.dart';
import 'package:iJot/widgets/privacy_policy.dart';
import 'package:iJot/widgets/progress.dart';
import 'package:iJot/widgets/snackbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _hidePassword = true;
  String _emailInput;
  String _passwordInput;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleSignIn() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();

      try {
        final authUser = await fireBaseAuth.signInWithEmailAndPassword(
          email: _emailInput.trim(),
          password: _passwordInput.trim(),
        );
        if (authUser != null) {
          final User currentUser = fireBaseAuth.currentUser;
          String userId = currentUser.uid;

          loggedInUserId = userId;

          userBox.put('userId', userId);

          await FirebaseMethods().cloudToLocal();
          await HiveMethods().checkForUserItems();

          setState(() {
            _isLoading = false;
          });

          context.vxNav.replace(Uri.parse(MyRoutes.notesRoute));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showErrorSnackbar(context, message: e.message);
      }
    }
  }

  _handleGoogleSignIn() {
    try {
      googleSignIn.signIn();
    } catch (e) {
      print('Error Signing in: $e');
      showErrorSnackbar(context,
          message: 'Unable to Sign in with Google, try again.');
    }
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) async {
      setState(() {
        _isLoading = true;
      });
      final GoogleSignInAccount currentUser = googleSignIn.currentUser;
      String userId = currentUser.id;

      loggedInUserId = userId;

      userBox.put('userId', userId);
      await FirebaseMethods().cloudToLocal();
      await HiveMethods().checkForUserItems();

      setState(() {
        _isLoading = false;
      });
      context.vxNav.replace(Uri.parse(MyRoutes.notesRoute));
    }, onError: (error) {
      print('Error Signing in: $error');
      showErrorSnackbar(context,
          message: 'Unable to Sign in with Google, try again.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasTopBars: false,
      hasBottomBars: false,
      title: 'sign_in'.tr(),
      shouldShrink: false,
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
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth > 700 ? 400 : double.infinity,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo-with-circle.png',
                            height: 115.0,
                          ),
                          SizedBox(height: 55.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      kCircularBorderRadius),
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
                                  borderRadius: BorderRadius.circular(
                                      kCircularBorderRadius),
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
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
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
                                    ),
                                    obscureText: _hidePassword,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                GestureDetector(
                                  onTap: () =>
                                      showForgotPasswordBottomSheet(context),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Text(
                                      'forgot_password'.tr(),
                                      style: kNormalUnderlineTextStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                CustomButton(
                                  buttonColor: Theme.of(context).primaryColor,
                                  text: 'sign_in'.tr(),
                                  textColor: Colors.white,
                                  onTap: handleSignIn,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'or'.tr(),
                                  style: TextStyle(
                                    color: Color(0x80FFFFFF),
                                    fontSize: 12.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                CustomButton(
                                  buttonColor: Colors.white,
                                  onTap: _handleGoogleSignIn,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google-logo.png',
                                        width: 30.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        'sign_in'.tr(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'dont_have_an_account'.tr() + " ",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontFamily: 'Cabin',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.vxNav
                                    .push(Uri.parse(MyRoutes.registerRoute)),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    'register'.tr(),
                                    style: kNormalUnderlineTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.07),
                          PrivacyPolicyWidget(),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
