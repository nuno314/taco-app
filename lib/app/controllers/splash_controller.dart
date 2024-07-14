import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

import '/app/controllers/controller.dart';

class SplashController extends Controller {
  bool get isLoggedIn => _isLoggedIn.value;
  late final Signal<bool> _isLoggedIn;

  @override
  construct(BuildContext context) {
    super.construct(context);
    _isLoggedIn = Solid.get<AuthSolidController>(context).isLoggedIn;
  }
}
