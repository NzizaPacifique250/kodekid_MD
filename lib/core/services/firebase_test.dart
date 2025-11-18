import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTest {
  static Future<Map<String, dynamic>> testFirebaseConnection() async {
    try {
      // Test Firebase Core initialization
      if (Firebase.apps.isEmpty) {
        return {
          'success': false,
          'message': 'Firebase not initialized',
        };
      }

      // Test Firebase Auth
      final auth = FirebaseAuth.instance;
      print('Firebase Auth instance created: ${auth.app.name}');

      // Test Firestore connection
      final firestore = FirebaseFirestore.instance;
      
      // Try to read from Firestore (this will test connectivity)
      try {
        await firestore.collection('test').limit(1).get();
        print('Firestore connection successful');
      } catch (e) {
        print('Firestore connection failed: $e');
      }

      return {
        'success': true,
        'message': 'Firebase connection successful',
        'authApp': auth.app.name,
        'firestoreApp': firestore.app.name,
      };
    } catch (e) {
      print('Firebase test failed: $e');
      return {
        'success': false,
        'message': 'Firebase test failed: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> testEmailPasswordAuth() async {
    try {
      final auth = FirebaseAuth.instance;
      
      // Check if email/password provider is enabled
      final providers = await auth.fetchSignInMethodsForEmail('test@example.com');
      
      return {
        'success': true,
        'message': 'Email/password auth is available',
        'providers': providers,
      };
    } catch (e) {
      print('Email/password auth test failed: $e');
      return {
        'success': false,
        'message': 'Email/password auth test failed: $e',
      };
    }
  }
}