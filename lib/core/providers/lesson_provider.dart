import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/progress_service.dart';
import '../services/code_storage_service.dart';
import '../services/gamification_service.dart';
import '../../features/auth/data/auth_service.dart';

final lessonProgressProvider = StateNotifierProvider.family<LessonProgressNotifier, AsyncValue<Map<String, dynamic>?>, int>((ref, lessonId) {
  return LessonProgressNotifier(lessonId);
});

class LessonProgressNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final int lessonId;
  
  LessonProgressNotifier(this.lessonId) : super(const AsyncValue.loading()) {
    loadProgress();
  }

  Future<void> loadProgress() async {
    try {
      final userId = AuthService.currentUser?.uid;
      if (userId == null) {
        state = const AsyncValue.data(null);
        return;
      }
      
      final progress = await ProgressService.getLessonProgress(userId, lessonId);
      state = AsyncValue.data(progress);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateProgress({bool? completed, int? score, String? code}) async {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) return;

    try {
      await ProgressService.updateLessonProgress(
        userId, 
        lessonId,
        completed: completed ?? false,
        score: score ?? 0,
        code: code,
      );
      
      if (completed == true) {
        await GamificationService.updateAchievement(userId, 'lessons_completed', 1);
        await GamificationService.awardBadge(userId, 'lesson_$lessonId', 'Lesson $lessonId Complete');
      }
      
      await loadProgress();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final userCodeProvider = StateNotifierProvider.family<UserCodeNotifier, AsyncValue<String>, int>((ref, lessonId) {
  return UserCodeNotifier(lessonId);
});

class UserCodeNotifier extends StateNotifier<AsyncValue<String>> {
  final int lessonId;
  
  UserCodeNotifier(this.lessonId) : super(const AsyncValue.loading()) {
    loadCode();
  }

  Future<void> loadCode() async {
    try {
      final userId = AuthService.currentUser?.uid;
      if (userId == null) {
        state = const AsyncValue.data('');
        return;
      }
      
      final code = await CodeStorageService.loadCode(userId, lessonId);
      state = AsyncValue.data(code ?? '');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> saveCode(String code) async {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) return;

    try {
      await CodeStorageService.saveCode(userId, lessonId, code);
      state = AsyncValue.data(code);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}