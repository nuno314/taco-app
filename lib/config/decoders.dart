import 'package:flutter_app/app/controllers/sign_up_controller.dart';
import 'package:flutter_app/app/controllers/splash_controller.dart';

import '/app/controllers/home_controller.dart';
import '/app/controllers/login_controller.dart';
import '../app/models/profile.dart';
import '/app/networking/api_service.dart';

/* Model Decoders
|--------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/5.20.0/decoders#model-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> modelDecoders = {
  List<Profile>: (data) =>
      List.from(data).map((json) => Profile.fromJson(json)).toList(),
  //
  Profile: (data) => Profile.fromJson(data),

  // User: (data) => User.fromJson(data),
};

/* API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/5.20.0/decoders#api-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  // ...
};

/* Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
|
| Learn more https://nylo.dev/docs/5.20.0/controllers
|-------------------------------------------------------------------------- */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),
  SplashController: () => SplashController(),

  // ...

  LoginController: () => LoginController(),
  SignUpController: () => SignUpController(),
};
