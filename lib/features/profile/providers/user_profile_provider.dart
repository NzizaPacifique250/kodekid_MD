import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_profile_model.dart';
import '../data/user_profile_service.dart';

// Simple provider for user profile
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  return await UserProfileService.getCurrentUserProfile();
});

// Provider for updating profile
final userProfileUpdateProvider = Provider<UserProfileUpdate>((ref) {
  return UserProfileUpdate(ref);
});

class UserProfileUpdate {
  final Ref ref;
  
  UserProfileUpdate(this.ref);
  
  Future<bool> updateProfile(String name, String email) async {
    try {
      final currentProfile = await ref.read(userProfileProvider.future);
      if (currentProfile == null) return false;
      
      final updatedProfile = currentProfile.copyWith(name: name, email: email);
      final success = await UserProfileService.updateUserProfile(updatedProfile);
      
      if (success) {
        // Refresh the provider
        ref.invalidate(userProfileProvider);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}