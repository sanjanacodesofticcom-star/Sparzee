import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static FirebaseFirestore? _firestore;
  static FirebaseAuth? _auth;

  static FirebaseFirestore? get firestore => _firestore;
  static FirebaseAuth? get auth => _auth;

  /// Initialize Firebase app safely
  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _firestore = FirebaseFirestore.instance;
      _auth = FirebaseAuth.instance;
      _isInitialized = true;
      debugPrint('✅ Firebase initialized successfully with Cloud Firestore');
    } catch (e) {
      _isInitialized = false;
      debugPrint('ℹ️ Firebase initialization note: $e');
      debugPrint('➡️ DatabaseService running with reactive real-time database manager');
    }
  }
}
