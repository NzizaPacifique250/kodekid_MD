import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/course_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/persistent_bottom_nav.dart';
import '../domain/course_model.dart';
import 'widgets/course_item.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesStreamProvider);

    final Widget content = coursesAsync.when(
      data: (courses) => SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            // Courses List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: courses.map((coreCourse) {
                  // Map backend/core Course to presentation CourseModel
                  final item = CourseModel(
                    id: coreCourse.chapter,
                    title: coreCourse.title,
                    videoUrl: coreCourse.videoLink ?? '',
                    hasGeeksterLogo: false,
                  );
                  return CourseItem(course: item, courseDocId: coreCourse.id);
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Failed to load courses: $err')),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main content (async)
          content,
          // Decorative elements
          // Orange decorative element (right side)
          Positioned(
            right: -50,
            top: 200,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Blue decorative element (left side)
          Positioned(
            left: -50,
            bottom: 100,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const PersistentBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Logo
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/logo kidkoder.svg',
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/logo kidkoder.svg',
                    height: 50,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // COURSES title
          Text(
            'COURSES',
            style: AppTextStyles.sectionHeadline(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
