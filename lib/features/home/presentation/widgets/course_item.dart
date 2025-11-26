import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/course_model.dart';


class CourseItem extends ConsumerWidget {
  final CourseModel course;
  final String? courseDocId;
  final bool showPlayButton;

  const CourseItem({
    super.key,
    required this.course,
    this.courseDocId,
    this.showPlayButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          GestureDetector(
            onTap: () => _navigateToLesson(context),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.darkGreen, AppColors.darkGreenLight],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 56,
                    right: 100,
                    child: Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ).copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLesson(BuildContext context) {
    final args = courseDocId != null
        ? {'courseId': courseDocId}
        : {'lessonId': course.id};
    Navigator.pushNamed(context, AppRoutes.lessonDetail, arguments: args);
  }
}
