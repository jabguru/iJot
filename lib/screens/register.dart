import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:iJot/constants/constants.dart';
import 'package:iJot/constants/firebase.dart';
import 'package:iJot/screens/login.dart';
import 'package:iJot/screens/notes.dart';
import 'package:iJot/widgets/custom_scaffold.dart';
import 'package:iJot/widgets/progress.dart';
import 'package:iJot/widgets/snackbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
          final FirebaseUser currentUser = await fireBaseAuth.currentUser();
          String userId = currentUser.uid;

          setState(() {
            loggedInUserId = userId;
          });

          userBox = Hive.box('user');
          userBox.put('userId', userId);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Notes()));
        }
      } on PlatformException catch (e) {
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
      title: 'Sign Up',
      hasBars: false,
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
                        autovalidate: true,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kCircularBorderRadius),
                              child: TextFormField(
                                validator: (val) {
                                  if (val.trim().isEmpty) {
                                    return 'Please input email';
                                  } else if (!val.trim().contains(RegExp(
                                      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
                                      caseSensitive: false))) {
                                    return 'Input a valid email!';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) => _emailInput = value,
                                style: kInputTextStyle,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Email',
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
                                    return 'Input a password';
                                  } else if (val.trim().length < 6) {
                                    return 'Password too short';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) => _passwordInput = value,
                                style: kInputTextStyle,
                                decoration: InputDecoration(
                                  hintText: 'Password',
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
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(height: 8.0),
                            // Text(
                            //   'OR',
                            //   style: TextStyle(
                            //     color: Color(0x80FFFFFF),
                            //     fontSize: 12.0,
                            //   ),
                            // ),
                            // SizedBox(height: 8.0),
                            // Container(
                            //   height: 48.0,
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(
                            //         kCircularBorderRadius),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Image.asset('assets/images/google-logo.png'),
                            //       SizedBox(width: 8.0),
                            //       Text(
                            //         'Sign Up',
                            //         style: TextStyle(
                            //           fontSize: 20.0,
                            //           color: Theme.of(context).primaryColor,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Column(
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
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
