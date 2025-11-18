import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in and email is verified
  static bool get isLoggedIn => _auth.currentUser != null && _auth.currentUser!.emailVerified;

  // Get current user email
  static String? get currentUserEmail => _auth.currentUser?.email;

  // Get current user name (synchronous)
  static String get currentUserName => _auth.currentUser?.displayName ?? _auth.currentUser?.email?.split('@').first ?? 'User';

  // Check if email is verified
  static bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Login with email and password
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        if (!credential.user!.emailVerified) {
          return {
            'success': false,
            'message': 'Please verify your email before logging in.',
            'needsVerification': true,
          };
        }
        return {'success': true, 'message': 'Login successful'};
      }
      return {'success': false, 'message': 'Login failed'};
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again.'};
    }
  }

  // Register new user with email verification
  static Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name);
        
        // Save user data to Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        // Send email verification
        await credential.user!.sendEmailVerification();
        
        return {
          'success': true,
          'message': 'Registration successful! Please check your email to verify your account.',
          'needsVerification': true,
        };
      }
      return {'success': false, 'message': 'Registration failed'};
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again.'};
    }
  }

  // Send email verification
  static Future<bool> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Reload user to check verification status
  static Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user name
  static Future<String?> getCurrentUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName;
      }
      // Fallback to Firestore
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.data()?['name'];
      } catch (e) {
        return user.email?.split('@').first;
      }
    }
    return null;
  }
}

