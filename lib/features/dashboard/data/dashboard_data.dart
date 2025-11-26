import '../domain/chapter_progress_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/data/auth_service.dart';

class DashboardData {
  // Get current user name from auth service
  static String getCurrentUserName() {
    final userName = AuthService.currentUserName;
    return userName ?? 'User'; // Default to 'User' if not logged in
  }

  // Get chapter progress data
  static List<ChapterProgressModel> getChapterProgress() {
    return [
      ChapterProgressModel(
        chapterNumber: 1,
        title: 'Chapter 1',
        progressPercentage: 0,
        completedStars: 0, // Start with 0 stars for new users
        chapterColor: AppColors.oliveGreen,
      ),
      ChapterProgressModel(
        chapterNumber: 2,
        title: 'Chapter 2',
        progressPercentage: 0,
        completedStars: 0,
        chapterColor: AppColors.orange,
      ),
      ChapterProgressModel(
        chapterNumber: 3,
        title: 'Chapter 3',
        progressPercentage: 0,
        completedStars: 0,
        chapterColor: AppColors.yellow,
      ),
      ChapterProgressModel(
        chapterNumber: 4,
        title: 'Chapter 4',
        progressPercentage: 0,
        completedStars: 0,
        chapterColor: AppColors.darkGrey,
      ),
    ];
  }
}

