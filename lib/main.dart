import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/home/presentation/landing_page.dart';
import 'features/home/presentation/courses_page.dart';
import 'features/lessons/presentation/lesson_detail_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/profile/presentation/edit_profile_page.dart';
import 'features/profile/presentation/settings_page.dart';
import 'features/profile/presentation/help_support_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/email_verification_page.dart';
import 'features/auth/presentation/logout_page.dart';
import 'core/navigation/navigation_service.dart';
import 'core/widgets/app_wrapper.dart';
import 'core/widgets/auth_wrapper.dart';
import 'core/providers/theme_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: provider.ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'KodeKid',
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            return AppWrapper(child: child);
          },
          initialRoute: AppRoutes.landing,
          routes: {
            AppRoutes.landing: (context) => const AuthWrapper(),
            '/home': (context) => const LandingPage(),
            AppRoutes.courses: (context) => const CoursesPage(),
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.editProfile: (context) => const EditProfilePage(),
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.helpSupport: (context) => const HelpSupportPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.emailVerification: (context) => const EmailVerificationPage(),
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
      },
    );
  }
}
