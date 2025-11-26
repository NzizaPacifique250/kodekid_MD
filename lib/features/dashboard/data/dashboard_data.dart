import '../domain/chapter_progress_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/progress_service.dart';
import '../../auth/data/auth_service.dart';

class DashboardData {
  // Get current user name from auth service
  static String getCurrentUserName() {
    final userName = AuthService.currentUserName;
    return userName ?? 'User'; // Default to 'User' if not logged in
  }

  // Get chapter progress data with real user progress
  static Future<List<ChapterProgressModel>> getChapterProgress() async {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) {
      return _getDefaultProgress();
    }

    try {
      final progress = await ProgressService.getUserProgress(userId);
      return _convertToChapterProgress(progress);
    } catch (e) {
      return _getDefaultProgress();
    }
  }

  static List<ChapterProgressModel> _convertToChapterProgress(List<Map<String, dynamic>> progress) {
    final Map<int, List<Map<String, dynamic>>> chapterGroups = {};
    
    for (final lesson in progress) {
      final lessonId = lesson['lessonId'] as int;
      final chapterNum = (lessonId / 10).floor() + 1; // Assuming 10 lessons per chapter
      
      chapterGroups[chapterNum] ??= [];
      chapterGroups[chapterNum]!.add(lesson);
    }

    final chapters = <ChapterProgressModel>[];
    final colors = [AppColors.oliveGreen, AppColors.orange, AppColors.yellow, AppColors.darkGrey];
    
    for (int i = 1; i <= 4; i++) {
      final lessons = chapterGroups[i] ?? [];
      final completedLessons = lessons.where((l) => l['completed'] == true).length;
      final totalLessons = lessons.isEmpty ? 10 : lessons.length;
      final progressPercentage = totalLessons > 0 ? (completedLessons / totalLessons * 100).round() : 0;
      final stars = (progressPercentage / 33.33).ceil().clamp(0, 3);
      
      chapters.add(ChapterProgressModel(
        chapterNumber: i,
        title: 'Chapter $i',
        progressPercentage: progressPercentage,
        completedStars: stars,
        chapterColor: colors[(i - 1) % colors.length],
      ));
    }
    
    return chapters;
  }

  static List<ChapterProgressModel> _getDefaultProgress() {
    return [
      ChapterProgressModel(
        chapterNumber: 1,
        title: 'Chapter 1',
        progressPercentage: 0,
        completedStars: 0,
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

