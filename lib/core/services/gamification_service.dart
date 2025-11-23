import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class GamificationService {
  static const String _badgesCollection = 'user_badges';
  static const String _achievementsCollection = 'achievements';

  static Future<void> awardBadge(String userId, String badgeId, String badgeName) async {
    final data = {
      'userId': userId,
      'badgeId': badgeId,
      'badgeName': badgeName,
      'earnedAt': DateTime.now().toIso8601String(),
    };
    
    await FirebaseService.addDocument(_badgesCollection, data);
  }

  static Future<List<Map<String, dynamic>>> getUserBadges(String userId) async {
    final snapshot = await FirebaseService.firestore
        .collection(_badgesCollection)
        .where('userId', isEqualTo: userId)
        .get();
    
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> updateAchievement(String userId, String type, int value) async {
    final docId = '${userId}_$type';
    final existing = await FirebaseService.getDocument(_achievementsCollection, docId);
    
    final currentValue = existing?['value'] ?? 0;
    final newValue = currentValue + value;
    
    await FirebaseService.firestore
        .collection(_achievementsCollection)
        .doc(docId)
        .set({
      'userId': userId,
      'type': type,
      'value': newValue,
      'lastUpdated': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, int>> getUserStats(String userId) async {
    final snapshot = await FirebaseService.firestore
        .collection(_achievementsCollection)
        .where('userId', isEqualTo: userId)
        .get();
    
    final stats = <String, int>{};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      stats[data['type']] = data['value'] ?? 0;
    }
    
    return stats;
  }
}