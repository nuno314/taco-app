import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/bootstrap/app.dart';
import 'bootstrap/boot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Nylo nylo = await Nylo.init(
    setup: Boot.nylo,
    setupFinished: Boot.finished,
  );

  await Supabase.initialize(
    url: getEnv('SUPABASE_URL'),
    anonKey: getEnv('SUPABASE_KEY'),
  );

  runApp(
    AppBuild(
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nylo.router!.generator(),
      debugShowCheckedModeBanner: false,
      initialRoute: nylo.getInitialRoute(),
      navigatorObservers: nylo.getNavigatorObservers(),
    ),
  );
}
