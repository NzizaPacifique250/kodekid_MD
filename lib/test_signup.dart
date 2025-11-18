import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignupTest {
  static Future<void> testSignup() async {
    try {
      print('Testing Firebase signup...');
      
      // Test Firebase initialization
      if (Firebase.apps.isEmpty) {
        print('ERROR: Firebase not initialized');
        return;
      }
      print('✓ Firebase initialized');
      
      // Test Firebase Auth
      final auth = FirebaseAuth.instance;
      print('✓ Firebase Auth instance created');
      
      // Test signup with a test email
      final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
      final testPassword = 'test123456';
      
      print('Attempting signup with: $testEmail');
      
      final credential = await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      
      if (credential.user != null) {
        print('✓ User created successfully: ${credential.user!.uid}');
        
        // Send verification email
        await credential.user!.sendEmailVerification();
        print('✓ Verification email sent');
        
        // Clean up - delete test user
        await credential.user!.delete();
        print('✓ Test user deleted');
        
        print('SUCCESS: Signup is working correctly!');
      } else {
        print('ERROR: No user returned from signup');
      }
      
    } catch (e) {
      print('ERROR during signup test: $e');
    }
  }
}