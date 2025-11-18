import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/course_model.dart';

class CourseItem extends StatelessWidget {
  final CourseModel course;

  const CourseItem({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course number and title
          GestureDetector(
            onTap: () => _navigateToLesson(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                '${course.id}. ${course.title}',
                style: AppTextStyles.bodyText(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Video thumbnail
          GestureDetector(
            onTap: () => _navigateToLesson(context),
            child: Stack(
              children: [
                // Thumbnail container with gradient
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.darkGreen,
                        AppColors.darkGreenLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                child: Stack(
                  children: [
                    // Top grey bar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: AppColors.lightGrey.withOpacity(0.5),
                      ),
                    ),
                    // Bottom grey bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: AppColors.lightGrey.withOpacity(0.5),
                      ),
                    ),
                    // Course title text on thumbnail
                    Positioned(
                      left: 20,
                      top: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Introduction',
                            style: AppTextStyles.bodyText(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ).copyWith(color: AppColors.white),
                          ),
                          Text(
                            'to Python',
                            style: AppTextStyles.bodyText(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ).copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                    // Geekster logo (if applicable)
                    if (course.hasGeeksterLogo)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.limeGreen.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'G Geekster',
                            style: AppTextStyles.bodyText(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ).copyWith(color: AppColors.darkGrey),
                          ),
                        ),
                      ),
                    // Python logo placeholder (top right)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.code,
                          color: AppColors.yellow,
                          size: 24,
                        ),
                      ),
                    ),
                    // Play button (center-right)
                    Positioned(
                      right: 40,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: AppColors.darkGrey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLesson(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.lessonDetail,
      arguments: {'lessonId': course.id},
    );
  }
}

