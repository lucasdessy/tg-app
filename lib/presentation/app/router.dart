import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:sales_platform_app/presentation/app/home.dart';
import 'package:sales_platform_app/presentation/profile/change_password_page.dart';
import 'package:sales_platform_app/presentation/splash/splash_page.dart';
import 'package:sales_platform_app/presentation/training/training_page.dart';

import '../login/login_page.dart';
import '../login/reset_password_page.dart';
import '../media/media_page.dart';
import '../profile/edit_profile_page.dart';

@singleton
class AppRouter with Printable {
  final AnalyticsService _analyticsService;
  AppRouter(this._analyticsService);
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    log("onGenerateRoute: ${settings.name}");
    _analyticsService.registerPageNavigateEvent("${settings.name}");
    if (settings.name == AppRoutes.splash.path) {
      return MaterialPageRoute(
        builder: (context) => const SplashPage(),
      );
    }
    if (settings.name == AppRoutes.home.path) {
      return MaterialPageRoute(
        builder: (context) => const AppHomePage(),
      );
    }
    if (settings.name == AppRoutes.login.path) {
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    }
    if (settings.name == AppRoutes.editProfile.path) {
      return MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      );
    }
    if (settings.name == AppRoutes.resetPassword.path) {
      return MaterialPageRoute(
        builder: (context) => const ResetPasswordPage(),
      );
    }
    if (settings.name == AppRoutes.changePassword.path) {
      return MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      );
    }
    if (settings.name == AppRoutes.training.path) {
      final argument = settings.arguments as TrainingPageProps;
      return MaterialPageRoute(
        builder: (context) => TrainingPage(props: argument),
      );
    }
    if (settings.name == AppRoutes.media.path) {
      final argument = settings.arguments as MediaPageProps;
      return MaterialPageRoute(
        builder: (context) => MediaPage(props: argument),
      );
    }
    return null;
  }
}

enum AppRoutes {
  splash("/"),
  home("/home"),
  login("/login"),
  editProfile("/profile"),
  resetPassword("/login/reset-password"),
  changePassword("/profile/change-password"),
  training("/training"),
  media("/media");

  final String path;
  const AppRoutes(this.path);
}
