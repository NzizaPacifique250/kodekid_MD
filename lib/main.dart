import 'package:flutter/material.dart';
import 'features/home/presentation/landing_page.dart';
import 'features/home/presentation/courses_page.dart';
import 'features/lessons/presentation/lesson_detail_page.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (context) => const LandingPage(),
        AppRoutes.courses: (context) => const CoursesPage(),
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
