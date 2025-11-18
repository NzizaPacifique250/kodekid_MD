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
      print('=== REGISTRATION DEBUG START ===');
      print('Email: $email');
      print('Password length: ${password.length}');
      print('Name: $name');
      print('Firebase Auth instance: ${_auth.app.name}');
      
      // Validate inputs before attempting registration
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        print('ERROR: Empty fields detected');
        return {'success': false, 'message': 'All fields are required'};
      }
      
      if (password.length < 6) {
        print('ERROR: Password too short');
        return {'success': false, 'message': 'Password must be at least 6 characters'};
      }
      
      print('Calling createUserWithEmailAndPassword...');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      print('✓ User created successfully: ${credential.user?.uid}');
      print('✓ User email: ${credential.user?.email}');
      
      if (credential.user != null) {
        // Update display name
        print('Updating display name...');
        await credential.user!.updateDisplayName(name.trim());
        print('✓ Display name updated');
        
        // Save user data to Firestore (non-blocking)
        print('Saving to Firestore...');
        _firestore.collection('users').doc(credential.user!.uid).set({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': false,
        }).then((_) {
          print('✓ Firestore save successful');
        }).catchError((error) {
          print('⚠ Firestore save error (non-critical): $error');
        });
        
        // Send email verification
        print('Sending email verification...');
        await credential.user!.sendEmailVerification();
        print('✓ Email verification sent successfully');
        
        print('=== REGISTRATION SUCCESS ===');
        return {
          'success': true,
          'message': 'Registration successful! Please check your email to verify your account.',
          'needsVerification': true,
        };
      }
      print('ERROR: No user returned from Firebase');
      return {'success': false, 'message': 'Registration failed - no user created'};
    } on FirebaseAuthException catch (e) {
      print('=== FIREBASE AUTH ERROR ===');
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
      print('Stack trace: ${e.stackTrace}');
      
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'email-already-in-use':
          // Check if the existing account is unverified
          try {
            final signInResult = await _auth.signInWithEmailAndPassword(
              email: email.trim().toLowerCase(),
              password: password,
            );
            if (signInResult.user != null && !signInResult.user!.emailVerified) {
              // Account exists but not verified - resend verification
              await signInResult.user!.sendEmailVerification();
              return {
                'success': true,
                'message': 'Account exists but not verified. Verification email sent again!',
                'needsVerification': true,
              };
            }
          } catch (signInError) {
            // If sign-in fails, it means password is different
            message = 'An account with this email already exists. Please use a different email or try logging in.';
            break;
          }
          message = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'operation-not-allowed':
          message = 'Email registration is not enabled. Contact support.';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your internet connection.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'Registration failed. Please try again.';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      print('=== UNEXPECTED ERROR ===');
      print('Error: $e');
      print('Type: ${e.runtimeType}');
      return {'success': false, 'message': 'Registration failed. Please try again.'};
    }
  }

  // Send email verification
  static Future<bool> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Email verification sent to: ${user.email}');
        return true;
      }
      print('Cannot send verification: user is null or already verified');
      return false;
    } catch (e) {
      print('Error sending email verification: $e');
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

  // Handle existing unverified account
  static Future<Map<String, dynamic>> handleExistingAccount(String email, String password) async {
    try {
      // Try to sign in with the existing account
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      if (credential.user != null) {
        if (!credential.user!.emailVerified) {
          // Resend verification email
          await credential.user!.sendEmailVerification();
          return {
            'success': true,
            'message': 'Verification email sent! Please check your email.',
            'needsVerification': true,
          };
        } else {
          return {
            'success': true,
            'message': 'Account already verified. You can log in.',
          };
        }
      }
      return {'success': false, 'message': 'Failed to access existing account'};
    } catch (e) {
      return {
        'success': false, 
        'message': 'Wrong password for existing account. Please try logging in instead.',
      };
    }
  }
}

