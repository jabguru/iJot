import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/services/account.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/privacy_policy.dart';
import 'package:ijot/widgets/progress.dart';
import 'package:ijot/widgets/show_password.dart';
import 'package:ijot/widgets/snackbar.dart';
import 'package:ijot/widgets/textfield.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
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
        final fireBaseAuth = FirebaseAuth.instance;
        await fireBaseAuth.createUserWithEmailAndPassword(
            email: _emailInput!.trim(), password: _passwordInput!.trim());
        final User currentUser = fireBaseAuth.currentUser!;
        String userId = currentUser.uid;

        await AccountService.login(userId);

        if (context.mounted) {
          context.go(MyRoutes.homeRoute);
        }
      } on FirebaseException catch (e) {
        if (context.mounted) {
          showErrorSnackbar(context, message: e.message);
        }
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
                          kVLargeVSpace,
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
                                kHalfVSpace,
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
                                kHalfVSpace,
                                CustomButton(
                                  buttonColor: Theme.of(context).primaryColor,
                                  onTap: handleSignUp,
                                  text: 'sign_up'.tr(),
                                  textColor: Colors.white,
                                )
                              ],
                            ),
                          ),
                          kHalfVSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${'already_have_an_account'.tr()} ",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontFamily: 'Cabin',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go(MyRoutes.loginRoute()),
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
