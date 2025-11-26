import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_model.dart';
import '../../../core/services/preferences_service.dart';

class UserProfileService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      
      return UserProfile(
        name: data?['name'] ?? user.displayName ?? user.email?.split('@').first ?? 'User',
        email: user.email ?? '',
        avatarUrl: data?['avatarUrl'],
      );
    } catch (e) {
      return UserProfile(
        name: user.displayName ?? user.email?.split('@').first ?? 'User',
        email: user.email ?? '',
      );
    }
  }

  static Future<bool> updateUserProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Update Firebase Auth display name
      await user.updateDisplayName(profile.name);
      
      // Save to SharedPreferences for quick access
      await PreferencesService.setUserName(profile.name);
      
      // Update Firestore document
      await _firestore.collection('users').doc(user.uid).update({
        'name': profile.name,
        'email': profile.email,
        'avatarUrl': profile.avatarUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      return false;
    }
  }
}