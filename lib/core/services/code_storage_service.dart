import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class CodeStorageService {
  static const String _collection = 'user_code';

  static Future<void> saveCode(String userId, int lessonId, String code) async {
    final data = {
      'userId': userId,
      'lessonId': lessonId,
      'code': code,
      'savedAt': DateTime.now().toIso8601String(),
    };
    
    await FirebaseService.firestore
        .collection(_collection)
        .doc('${userId}_$lessonId')
        .set(data, SetOptions(merge: true));
  }

  static Future<String?> loadCode(String userId, int lessonId) async {
    final doc = await FirebaseService.getDocument(_collection, '${userId}_$lessonId');
    return doc?['code'];
  }

  static Future<List<Map<String, dynamic>>> getUserCodes(String userId) async {
    final snapshot = await FirebaseService.firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('savedAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}