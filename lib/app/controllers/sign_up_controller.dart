import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

import '/app/controllers/controller.dart';

class SignUpController extends Controller {
  late final AuthSolidController authController;
  @override
  construct(BuildContext context) {
    super.construct(context);
    authController = Solid.get<AuthSolidController>(context);
  }

  Signal<AuthSignal> get authSignal => authController.authSignal;

  Future signUp({
    required String email,
    required String password,
  }) {
    return authController.signUp(
      email: email,
      password: password,
    );
  }
}
