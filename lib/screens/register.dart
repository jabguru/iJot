import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/firebase.dart';
import 'package:ijot/constants/hive.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/privacy_policy.dart';
import 'package:ijot/widgets/progress.dart';
import 'package:ijot/widgets/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _hidePassword = true;
  String? _emailInput;
  String? _passwordInput;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleSignUp() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();

      try {
        await fireBaseAuth.createUserWithEmailAndPassword(
            email: _emailInput!.trim(), password: _passwordInput!.trim());
        final User currentUser = fireBaseAuth.currentUser!;
        String userId = currentUser.uid;

        loggedInUserId = userId;

        userBox.put('userId', userId);

        context.beamToReplacementNamed(MyRoutes.notesRoute);
      } on FirebaseException catch (e) {
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
                  padding: const EdgeInsets.all(38.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth > 700 ? 400 : double.infinity,
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo-with-circle.png',
                              height: 115.0),
                          const SizedBox(height: 55.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                ClipRRect(
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
                                const SizedBox(height: 8.0),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      kCircularBorderRadius),
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val!.trim().isEmpty) {
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
                                const SizedBox(height: 8.0),
                                CustomButton(
                                  buttonColor: Theme.of(context).primaryColor,
                                  onTap: handleSignUp,
                                  text: 'sign_up'.tr(),
                                  textColor: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'already_have_an_account'.tr() + " ",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontFamily: 'Cabin',
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.beamToNamed(MyRoutes.loginRoute),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    'sign_in'.tr(),
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
    );
  }
}
