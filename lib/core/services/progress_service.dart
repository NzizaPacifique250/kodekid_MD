import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class ProgressService {
  static const String _collection = 'user_progress';

  static Future<void> updateLessonProgress(String userId, int lessonId, {
    bool completed = false,
    int score = 0,
    String? code,
  }) async {
    final data = {
      'userId': userId,
      'lessonId': lessonId,
      'completed': completed,
      'score': score,
      'lastUpdated': DateTime.now().toIso8601String(),
      if (code != null) 'lastCode': code,
    };
    
    await FirebaseService.firestore
        .collection(_collection)
        .doc('${userId}_$lessonId')
        .set(data, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getLessonProgress(String userId, int lessonId) async {
    return await FirebaseService.getDocument(_collection, '${userId}_$lessonId');
  }

  static Future<List<Map<String, dynamic>>> getUserProgress(String userId) async {
    final snapshot = await FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();
    
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>
    }).toList();
  }
}