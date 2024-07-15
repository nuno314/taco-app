import 'package:flutter/widgets.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';

class OnboardingController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  onNext() {
    NyStorage.store(StorageKey.newUser, false);
    routeTo(
      LoginPage.path,
      navigationType: NavigationType.pushAndForgetAll,
    );
  }
}
