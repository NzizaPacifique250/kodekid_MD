import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static int currentBottomNavIndex = 0;

  static void navigateToBottomNav(int index) {
    currentBottomNavIndex = index;
    String targetRoute;
    switch (index) {
      case 0:
        targetRoute = AppRoutes.home;
        break;
      case 1:
        targetRoute = AppRoutes.courses;
        break;
      case 2:
        targetRoute = AppRoutes.dashboard;
        break;
      case 3:
        targetRoute = AppRoutes.profile;
        break;
      default:
        return;
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      targetRoute,
      (route) {
        final name = route.settings.name;
        return name == AppRoutes.landing ||
            name == AppRoutes.courses ||
            name == AppRoutes.dashboard ||
            name == AppRoutes.profile;
      },
    );
  }

  static int getCurrentIndexFromRoute(String? routeName) {
    switch (routeName) {
      case AppRoutes.home:
        return 0;
      case AppRoutes.courses:
        return 1;
      case AppRoutes.dashboard:
        return 2;
      case AppRoutes.profile:
        return 3;
      default:
        return currentBottomNavIndex;
    }
  }
}
