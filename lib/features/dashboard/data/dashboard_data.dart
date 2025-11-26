import '../domain/chapter_progress_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/data/auth_service.dart';

class DashboardData {
  // Get current user name from auth service
  static String getCurrentUserName() {
    final userName = AuthService.currentUserName;
    return userName.isNotEmpty ? userName : 'User'; // Default to 'User' if not logged in
  }

  // Get chapter progress data
  static List<ChapterProgressModel> getChapterProgress() {
    return [
      ChapterProgressModel(
        chapterNumber: 1,
        title: 'Chapter 1',
        progressPercentage: 55,
        completedStars: 2, // 2 out of 3 stars filled
        chapterColor: AppColors.oliveGreen,
      ),
      ChapterProgressModel(
        chapterNumber: 3,
        title: 'Chapter 3',
        progressPercentage: 75,
        completedStars: 2,
        chapterColor: AppColors.yellow,
      ),
      ChapterProgressModel(
        chapterNumber: 2,
        title: 'Chapter 2',
        progressPercentage: 55,
        completedStars: 2,
        chapterColor: AppColors.orange,
      ),
      ChapterProgressModel(
        chapterNumber: 4,
        title: 'Chapter 4',
        progressPercentage: 15,
        completedStars: 1,
        chapterColor: AppColors.darkGrey,
      ),
    ];
  }
}

