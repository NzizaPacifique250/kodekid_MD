import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/progress_service.dart';
import '../services/gamification_service.dart';
import '../../features/auth/data/auth_service.dart';
import '../../features/dashboard/domain/chapter_progress_model.dart';
import '../constants/app_colors.dart';

final userProgressProvider = StateNotifierProvider<UserProgressNotifier, AsyncValue<List<ChapterProgressModel>>>((ref) {
  return UserProgressNotifier();
});

class UserProgressNotifier extends StateNotifier<AsyncValue<List<ChapterProgressModel>>> {
  UserProgressNotifier() : super(const AsyncValue.loading()) {
    loadUserProgress();
  }

  Future<void> loadUserProgress() async {
    try {
      final userId = AuthService.currentUser?.uid;
      if (userId == null) {
        state = AsyncValue.data(_getDefaultProgress());
        return;
      }
      
      final progress = await ProgressService.getUserProgress(userId);
      final chapters = _convertToChapterProgress(progress);
      state = AsyncValue.data(chapters);
    } catch (e) {
      state = AsyncValue.data(_getDefaultProgress());
    }
  }

  List<ChapterProgressModel> _convertToChapterProgress(List<Map<String, dynamic>> progress) {
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

  List<ChapterProgressModel> _getDefaultProgress() {
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

final userStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final userId = AuthService.currentUser?.uid;
  if (userId == null) return {};
  
  return await GamificationService.getUserStats(userId);
});

final userBadgesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final userId = AuthService.currentUser?.uid;
  if (userId == null) return [];
  
  return await GamificationService.getUserBadges(userId);
});