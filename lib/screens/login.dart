import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ijot/constants/colors.dart';
import 'package:ijot/constants/constants.dart';
import 'package:ijot/constants/routes.dart';
import 'package:ijot/constants/spaces.dart';
import 'package:ijot/providers/auth_provider.dart';
import 'package:ijot/widgets/button.dart';
import 'package:ijot/widgets/custom_scaffold.dart';
import 'package:ijot/widgets/password_reset.dart';
import 'package:ijot/widgets/privacy_policy.dart';
import 'package:ijot/widgets/progress.dart';
import 'package:ijot/widgets/show_password.dart';
import 'package:ijot/widgets/snackbar.dart';
import 'package:ijot/widgets/textfield.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key, this.redirectToDeleteAccount = false});
  final bool redirectToDeleteAccount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  bool _hidePassword = true;
  String? _emailInput;
  String? _passwordInput;

  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSignIn() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      ref
          .read(authNotifierProvider.notifier)
          .signIn(email: _emailInput!, password: _passwordInput!);
    }
  }

  @override
  void initState() {
    super.initState();
    ref
        .read(authNotifierProvider.notifier)
        .init(
          context: context,
          redirectToDeleteAccount: widget.redirectToDeleteAccount,
          isLogin: true,
        );
  }

  void _naviagateToScreenOnSuccess() {
    if (context.mounted) {
      context.go(
        widget.redirectToDeleteAccount
            ? MyRoutes.deleteAccountRoute
            : MyRoutes.homeRoute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (_, next) {
      next.when(
        data: (data) {
          _naviagateToScreenOnSuccess();
        },
        error: (error, st) {
          showErrorSnackbar(context, message: error.toString());
        },
        loading: () {},
      );
    });

    return PopScope(
      canPop: false,
      child: CustomScaffold(
        title: 'sign_in'.tr(),
        shouldShrink: false,
        child: ModalProgressHUD(
          inAsyncCall: ref.watch(authNotifierProvider).isLoading,
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width:
                              constraints.maxWidth > 700
                                  ? 400
                                  : double.infinity,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/logo-with-circle.png',
                                height: 115.0,
                              ),
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
                                      onSaved:
                                          (value) => _passwordInput = value,
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
                                    GestureDetector(
                                      onTap:
                                          () => showForgotPasswordBottomSheet(
                                            context,
                                          ),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text(
                                          'forgot_password'.tr(),
                                          style: kNormalUnderlineTextStyle,
                                        ),
                                      ),
                                    ),
                                    kHalfVSpace,
                                    CustomButton(
                                      buttonColor:
                                          Theme.of(context).primaryColor,
                                      text: 'sign_in'.tr(),
                                      textColor: Colors.white,
                                      onTap: _handleSignIn,
                                    ),
                                    kHalfVSpace,
                                    Text(
                                      'or'.tr(),
                                      style: const TextStyle(
                                        color: kGrey2,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    kHalfVSpace,
                                    CustomButton(
                                      buttonColor: Colors.white,
                                      onTap:
                                          ref
                                              .read(
                                                authNotifierProvider.notifier,
                                              )
                                              .signInWithGoogle,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/google-logo.png',
                                            width: 30.0,
                                          ),
                                          kHalfHSpace,
                                          Text(
                                            'sign_in'.tr(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              kHalfVSpace,
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
                                    onTap:
                                        () =>
                                            context.go(MyRoutes.registerRoute),
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
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                              const PrivacyPolicyWidget(),
                            ],
                          ),
                        );
                      },
                    ),
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
