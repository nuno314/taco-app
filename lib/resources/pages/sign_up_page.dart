import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/config/design.dart';
import 'package:flutter_app/resources/widgets/box_color.dart';
import 'package:flutter_app/resources/widgets/button_widget.dart';
import 'package:flutter_app/resources/widgets/input_container.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SignUpPage extends StatefulWidget {
  static const path = '/sign-up';

  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthController _authController;
  Effect? _effect;

  @override
  void initState() {
    super.initState();

    _authController = Solid.get<AuthController>(
      NyNavigator.instance.router.navigatorKey!.currentContext!,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _effect = Effect(
        (e) {
          final hasError = _authController.authSignal.value.isError;

          if (hasError == true) {
            showToastNotification(
              context,
              style: ToastNotificationStyleType.WARNING,
              description: 'Cannot sign up',
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final isSigningUpSignal = _authController.authSignal;

    return SignalBuilder(
      signal: isSigningUpSignal,
      builder: (context, value, child) => Stack(
        children: [
          BoxColor(
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 16,
              16,
              MediaQuery.of(context).padding.bottom + 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                BackButton(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Create your new account'),
                      SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _emailController,
                        title: 'Email',
                        hintText: 'Enter email',
                      ),
                      SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _passwordController,
                        title: 'Password',
                        hintText: 'Enter password',
                      ),
                      SizedBox(height: 48),
                      ButtonWidget.recommend(
                        context: context,
                        title: 'Sign Up',
                        onPressed: () {
                          _authController.signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
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
    _authController.dispose();
    super.dispose();
  }
}
