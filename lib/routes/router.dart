import '/resources/pages/onboarding_page.dart';
import 'package:flutter_app/resources/pages/sign_up_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/resources/pages/home_page.dart';
import '/resources/pages/login_page.dart';
import '/resources/pages/splash_page.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(
        SplashPage.path,
        (context) => SplashPage(),
        initialRoute: true,
      );
      router.route(
        HomePage.path,
        (context) => HomePage(),
      );
      // Add your routes here

      router.route(
        LoginPage.path,
        (context) => LoginPage(),
        transition: PageTransitionType.fade,
      );
      router.route(
        SignUpPage.path,
        (context) => SignUpPage(),
        transition: PageTransitionType.fade,
      );
      // router.route(NewPage.path, (context) => NewPage(), transition: PageTransitionType.fade);

      // Example using grouped routes
      // router.group(() => {
      //   "route_guards": [AuthRouteGuard()],
      //   "prefix": "/dashboard"
      // }, (router) {
      //
      //   router.route(AccountPage.path, (context) => AccountPage());
      // });
      router.route(OnboardingPage.path, (context) => OnboardingPage());
});
