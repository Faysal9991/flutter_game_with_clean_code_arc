// lib/data/repositories/auth_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_faysal_game/core/constants/firebase_collections.dart';
import 'package:flutter_faysal_game/core/utils/logger.dart';
import 'package:flutter_faysal_game/services/localdata_service.dart'; 
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseService = FirebaseFirestore.instance;
  final LocalStorageService _storage; // ← REPLACED HiveService

  AuthRepository(this._storage);

  // ────────────────────────────────────────────────
  // Auth State Stream + Auto Save
  // ────────────────────────────────────────────────
  Stream<User?> get userChanges {
    logger.i('Auth State Stream: Listening');
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        await _saveUserToPrefs(user);
      } else {
        await _storage.clearUser();
      }
      return user;
    });
  }

  // ────────────────────────────────────────────────
  // Sign In
  // ────────────────────────────────────────────────
  Future<User?> signIn(String email, String password) async {
    logger.i('Sign In: $email');
    try {
      if (kIsWeb && kDebugMode) {
        await _firebaseAuth.setSettings(forceRecaptchaFlow: false);
      }

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await _saveUserToPrefs(user);
        logger.i('Sign In Success');
      }
      return user;
    } on FirebaseAuthException catch (e, stack) {
      logger.e('Sign In Failed: ${e.code}', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────
  // Sign Up With Details
  // ────────────────────────────────────────────────
  Future<User?> signUpWithDetails({
    required String email,
    required String password,
    required String username,
    required String location,
  }) async {
    logger.i('Sign Up: $email');
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      final userDocRef = _firebaseService.collection('users').doc(user.uid);
      await userDocRef.set({
        'profile': {
          'username': username,
          'email': email,
          'displayName': username,
          'photoURL': null,
          'location': location,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        },
        'stats': {
          'greenCoins': 0,
          'xp': 0,
          'level': 0,
          'streak': 0,
          'currentStreakStartDate': FieldValue.serverTimestamp(),
          'longestStreak': 0,
          'totalTasksCompleted': 0,
        }
      });

      // Initialize badge
      await userDocRef.collection(FirebaseCollections.badges).doc('initBadge').set({
        'badgeName': 'Welcome Badge',
        'earnedAt': FieldValue.serverTimestamp(),
        'category': 'Onboarding',
      });

      // SAVE TO SharedPreferences
      await _saveUserToPrefs(user, username: username);

      return user;
    } on FirebaseAuthException catch (e, stack) {
      logger.e('Sign Up Failed: ${e.code}', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────
  // Sign Out
  // ────────────────────────────────────────────────
  Future<void> signOut() async {
    logger.i('Sign Out');
    try {
      await _firebaseAuth.signOut();
      await _storage.clearUser();
      logger.i('Sign Out Success');
    } catch (e, stack) {
      logger.e('Sign Out Failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────
  // Helper: Save to SharedPreferences
  // ────────────────────────────────────────────────
  Future<void> _saveUserToPrefs(User user, {String? username}) async {
    final name = username ?? user.displayName ?? 'User';
    await _storage.saveUser(
     user.uid,
  user.email ?? '',
     name,
    );
    logger.i('User saved locally: $user');
  }

  // ────────────────────────────────────────────────
  // Get Offline User
  // ────────────────────────────────────────────────
  Map<String, String?> get offlineUser => _storage.user;
}