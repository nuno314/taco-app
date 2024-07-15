import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/login_controller.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/config/design.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/sign_up_page.dart';
import 'package:flutter_app/resources/widgets/button_widget.dart';
import 'package:flutter_app/resources/widgets/input_container.dart';
import 'package:flutter_app/resources/widgets/safearea_widget.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginPage extends NyStatefulWidget<LoginController> {
  static const path = '/login';

  LoginPage({super.key}) : super(path, child: () => _LoginPageState());
}

class _LoginPageState extends NyState<LoginPage> {
  /// [LoginController] controller
  LoginController get controller => widget.controller;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  Effect? _effect;

  @override
  boot() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _effect = Effect(
        (e) {
          if (controller.loginState is LoginSuccessState) {
            routeTo(
              HomePage.path,
              navigationType: NavigationType.pushAndForgetAll,
            );
          }
          final hasError = controller.authSignal.value.isError;

          if (hasError == true) {
            showToastNotification(
              context,
              style: ToastNotificationStyleType.WARNING,
              description: 'Cannot sign in',
            );
          }
        },
      );
    });
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SignalBuilder(
      signal: controller.authController.authSignal,
      builder: (context, value, child) => Stack(
        children: [
          SafeAreaWidget(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    '🌮',
                    style: TextStyle(fontSize: 150),
                  ),
                  Text('Hi there!'),
                  Text('Sign in to your account'),
                  SizedBox(height: 16),
                  TextFieldWidget(
                    controller: _emailController,
                    title: 'Email',
                    hintText: 'Enter email',
                    focusNode: _emailFocusNode,
                    maxLines: 1,
                  ),
                  SizedBox(height: 16),
                  TextFieldWidget(
                    controller: _passwordController,
                    title: 'Password',
                    hintText: 'Enter password',
                    focusNode: _passwordFocusNode,
                    maxLines: 1,
                    onSubmitted: (value) {
                      controller.login(
                        email: _emailController.text,
                        password: value,
                      );
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 48),
                  ButtonWidget.primary(
                      context: context,
                      title: 'Sign In',
                      onPressed: () {
                        controller.login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      }),
                  SizedBox(height: 48),
                  Text('Not have an account yet?'),
                  SizedBox(height: 12),
                  ButtonWidget.recommend(
                    context: context,
                    title: 'Sign Up',
                    onPressed: () {
                      _emailFocusNode.unfocus();
                      _passwordFocusNode.unfocus();

                      Navigator.pushNamed(
                        context,
                        SignUpPage.path,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: value.isLoading,
            child: Container(
              color: ThemeColor.get(context).primaryAccent.withOpacity(0.1),
              child: loader,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _effect?.dispose();
    super.dispose();
  }
}
