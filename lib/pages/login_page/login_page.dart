import 'package:africoin/pages/dashboard_page/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:africoin/pages/forget_password_page/forget_password_page.dart';
import 'package:africoin/pages/signup_page/signup_page.dart';
import 'package:africoin/widgets/custom_button.dart';
import 'package:africoin/widgets/custom_form_button.dart';
import 'package:africoin/widgets/custom_input_field.dart';
import 'package:africoin/widgets/page_heading.dart';
import 'package:africoin/widgets/page_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        const PageHeading(title: 'Log-in'),
                        CustomInputField(
                          labelText: 'Email',
                          hintText: 'Your email id',
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Email is required!';
                            }
                            if (!EmailValidator.validate(textValue)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: 'Password',
                          hintText: 'Your password',
                          obscureText: true,
                          suffixIcon: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Password is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: size.width * 0.80,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap:
                                () => {
                                  Get.to(
                                    () => const ForgetPasswordPage(),
                                    transition: Transition.rightToLeft,
                                  ),
                                },
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                color: Color(0xff939393),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomButton(
                            text: 'SE CONNECTER',
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            isFullWidth: true,
                            onTap: () {
                              _handleLoginUser();
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account ? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () => {
                                      Get.to(
                                        () => const SignupPage(),
                                        transition: Transition.rightToLeft,
                                      ),
                                    },
                                child: const Text(
                                  'Sign-up',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff748288),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLoginUser() {
    // login user
    if (_loginFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Submitting data..')));
      // Naviguer vers la page tableau de bord
      Get.to(() => DashboardPage(), transition: Transition.rightToLeft);
    }
  }
}
