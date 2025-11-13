import 'package:flutter/material.dart';
import 'features/home/presentation/landing_page.dart';
import 'features/home/presentation/courses_page.dart';
import 'features/lessons/presentation/lesson_detail_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/logout_page.dart';
import 'core/navigation/navigation_service.dart';
import 'core/widgets/app_wrapper.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KodeKid',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return AppWrapper(child: child);
      },
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (context) => const LandingPage(),
        AppRoutes.courses: (context) => const CoursesPage(),
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.logout: (context) => const LogoutPage(),
        AppRoutes.lessonDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Map<String, dynamic> && args.containsKey('lessonId')) {
            return LessonDetailPage(lessonId: args['lessonId'] as int);
          }
          // Default to lesson 1 if no arguments provided
          return const LessonDetailPage(lessonId: 1);
        },
      },
    );
  }
}
