import 'firebase_service.dart';

class UserService {
  static const String _collection = 'users';

  static Future<String> createUser(Map<String, dynamic> userData) async {
    return await FirebaseService.addDocument(_collection, userData);
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await FirebaseService.getCollection(_collection);
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    return await FirebaseService.getDocument(_collection, userId);
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await FirebaseService.updateDocument(_collection, userId, userData);
  }

  static Future<void> deleteUser(String userId) async {
    await FirebaseService.deleteDocument(_collection, userId);
  }
}