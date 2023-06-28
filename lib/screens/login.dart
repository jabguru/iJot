import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/firebase.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/services/firebase.dart';
import 'package:ijot/services/hive.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/password_reset.dart';
import 'package:ijot/widgets/privacy_policy.dart';
import 'package:ijot/widgets/progress.dart';
import 'package:ijot/widgets/show_password.dart';
import 'package:ijot/widgets/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ijot/widgets/textfield.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _hidePassword = true;
  String? _emailInput;
  String? _passwordInput;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleSignIn() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();

      try {
        await fireBaseAuth.signInWithEmailAndPassword(
          email: _emailInput!.trim(),
          password: _passwordInput!.trim(),
        );
        final User currentUser = fireBaseAuth.currentUser!;
        String userId = currentUser.uid;

        loggedInUserId = userId;

        userBox.put('userId', userId);

        await FirebaseService().cloudToLocal();
        await HiveService().checkForUserItems();

        setState(() {
          _isLoading = false;
        });

        if (context.mounted) {
          context.beamToReplacementNamed(MyRoutes.notesRoute);
        }
      } on FirebaseException catch (e) {
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
      // print('Error Signing in: $e');
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
      final GoogleSignInAccount currentUser = googleSignIn.currentUser!;
      String userId = currentUser.id;

      loggedInUserId = userId;

      userBox.put('userId', userId);
      await FirebaseService().cloudToLocal();
      await HiveService().checkForUserItems();

      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        context.beamToReplacementNamed(MyRoutes.notesRoute);
      }
    }, onError: (error) {
      // print('Error Signing in: $error');
      showErrorSnackbar(context,
          message: 'Unable to Sign in with Google, try again.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
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
                    padding: const EdgeInsets.all(38.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width:
                            constraints.maxWidth > 700 ? 400 : double.infinity,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo-with-circle.png',
                              height: 115.0,
                            ),
                            const SizedBox(height: 55.0),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFieldWidget(
                                    validator: kEmailValidator,
                                    onSaved: (value) => _emailInput = value,
                                    hintText: 'email'.tr(),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 8.0),
                                  TextFieldWidget(
                                    validator: kPasswordValidator,
                                    onSaved: (value) => _passwordInput = value,
                                    hintText: 'password'.tr(),
                                    obscureText: _hidePassword,
                                    suffixIcon: ShowPasswordWidget(
                                      onTap: () {
                                        setState(() {
                                          _hidePassword = !_hidePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
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
                                  const SizedBox(height: 8.0),
                                  CustomButton(
                                    buttonColor: Theme.of(context).primaryColor,
                                    text: 'sign_in'.tr(),
                                    textColor: Colors.white,
                                    onTap: handleSignIn,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'or'.tr(),
                                    style: const TextStyle(
                                      color: Color(0x80FFFFFF),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  CustomButton(
                                    buttonColor: Colors.white,
                                    onTap: _handleGoogleSignIn,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google-logo.png',
                                          width: 30.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'sign_in'.tr(),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${'dont_have_an_account'.tr()} ",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily: 'Cabin',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context
                                      .beamToNamed(MyRoutes.registerRoute),
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
                            const PrivacyPolicyWidget(),
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
      ),
    );
  }
}
