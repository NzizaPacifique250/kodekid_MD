import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/chapter_progress_model.dart';

class ChapterProgressWidget extends StatelessWidget {
  final ChapterProgressModel chapter;

  const ChapterProgressWidget({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to lesson detail page for this chapter
        Navigator.pushNamed(
          context,
          AppRoutes.lessonDetail,
          arguments: {'lessonId': chapter.chapterNumber},
        );
      },
      child: Column(
        children: [
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isFilled = index < chapter.completedStars;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  color: isFilled ? AppColors.orange : AppColors.lightGrey,
                  size: 16,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Chapter Circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: chapter.chapterColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${chapter.chapterNumber}',
                style: AppTextStyles.bodyText(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ).copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Chapter Title and Percentage
          Text(
            '${chapter.title}: ${chapter.progressPercentage}%',
            style: AppTextStyles.bodyText(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

