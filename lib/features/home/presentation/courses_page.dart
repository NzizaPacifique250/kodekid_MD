import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/courses_data.dart';
import 'widgets/course_item.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = CoursesData.getCourses();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                _buildHeader(context),
                
                // Courses List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: courses.map((course) {
                      return CourseItem(course: course);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
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

