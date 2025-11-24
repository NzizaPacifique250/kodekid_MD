import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_service.dart';
import '../services/user_progress_service.dart';

/// StreamProvider that exposes the list of completed course ids for the
/// currently authenticated user. If no user is signed in, returns an empty
/// stream.
final completedCoursesProvider =
    StreamProvider.autoDispose<List<String>>((ref) {
  final uid = FirebaseService.auth.currentUser?.uid;
  if (uid == null) return const Stream<List<String>>.empty();
  return UserProgressService.streamCompletedCourses(uid);
});

/// A convenience FutureProvider to fetch completed courses once.
final completedCoursesOnceProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final uid = FirebaseService.auth.currentUser?.uid;
  if (uid == null) return <String>[];
  return UserProgressService.getCompletedCourses(uid);
});
