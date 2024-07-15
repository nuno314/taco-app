import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/box_color.dart';
import 'package:flutter_app/resources/widgets/button_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/onboarding_controller.dart';

class OnboardingPage extends NyStatefulWidget<OnboardingController> {
  static const path = '/onboarding';

  OnboardingPage({super.key})
      : super(path, child: () => _OnboardingPageState());
}

class _OnboardingPageState extends NyState<OnboardingPage> {
  /// [OnboardingController] controller
  OnboardingController get controller => widget.controller;

  @override
  init() async {}

  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: BoxColor(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120),
            Text(
              '🌮',
              style: TextStyle(fontSize: 150),
            ),
            Text(
              'Taco Report System',
              style: TextStyle(
                fontSize: 30,
                color: Colors.orange,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 20),
            Text('Submit, track reports and earn tacos'),
            SizedBox(height: 200),
            ButtonWidget.primary(
              context: context,
              title: '''Let's go''',
              onPressed: controller.onNext,
            )
          ],
        ),
      ),
    );
  }
}
