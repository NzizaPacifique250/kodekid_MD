import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

/// Service that stores per-user course completion information.
///
/// Stores a document per user in collection `user_progress` with a field
/// `completedCourses` (array of course doc ids).
class UserProgressService {
  static final CollectionReference _col =
      FirebaseService.firestore.collection('user_progress');

  /// Mark a course as completed for a given user.
  static Future<void> markCourseCompleted(String uid, String courseId) async {
    await _col.doc(uid).set(
      {
        'completedCourses': FieldValue.arrayUnion([courseId])
      },
      SetOptions(merge: true),
    );
  }

  /// Unmark a course as completed for a given user.
  static Future<void> unmarkCourseCompleted(String uid, String courseId) async {
    await _col.doc(uid).set(
      {
        'completedCourses': FieldValue.arrayRemove([courseId])
      },
      SetOptions(merge: true),
    );
  }

  /// Get completed course ids once.
  static Future<List<String>> getCompletedCourses(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) return [];
    final data = doc.data() as Map<String, dynamic>?;
    final list = (data?['completedCourses'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();
    return list ?? [];
  }

  /// Stream completed course ids for the user.
  static Stream<List<String>> streamCompletedCourses(String uid) {
    return _col.doc(uid).snapshots().map((snap) {
      if (!snap.exists) return <String>[];
      final data = snap.data() as Map<String, dynamic>?;
      final list = (data?['completedCourses'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList();
      return list ?? <String>[];
    });
  }

  /// Check if a specific course is completed for the user.
  static Future<bool> isCourseCompleted(String uid, String courseId) async {
    final list = await getCompletedCourses(uid);
    return list.contains(courseId);
  }
}
