import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/splash_controller.dart';

class SplashPage extends NyStatefulWidget<SplashController> {
  static const path = '/splash';

  SplashPage({super.key}) : super(path, child: () => _SplashPageState());
}

class _SplashPageState extends NyState<SplashPage> {
  /// [SplashController] controller
  SplashController get controller => widget.controller;

  @override
  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isLoggedIn) {
        routeTo(
          HomePage.path,
          navigationType: NavigationType.pushAndForgetAll,
        );
      } else {
        routeTo(LoginPage.path);
      }
    });
  }

  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Splash")),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
