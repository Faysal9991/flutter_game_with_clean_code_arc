// lib/data/repositories/auth_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_faysal_game/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ────────────────────────────────────────────────────────────────
  // Auth State Stream
  // ────────────────────────────────────────────────────────────────
  Stream<User?> get userChanges {
    logger.i('Auth State Stream: Listening for user changes');
    return _firebaseAuth.authStateChanges();
  }

  // ────────────────────────────────────────────────────────────────
  // Sign In
  // ────────────────────────────────────────────────────────────────
  Future<User?> signIn(String email, String password) async {
    logger.i('Sign In: Attempting login for $email');

    try {
      // Bypass reCAPTCHA only in debug mode (web)
      if (kIsWeb && kDebugMode) {
        await _firebaseAuth.setSettings(forceRecaptchaFlow: false);
        logger.d('reCAPTCHA: Bypassed for testing (web debug)');
      }

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        logger.i('Sign In Success: ${user.email} (UID: ${user.uid})');
      } else {
        logger.w('Sign In: Credential user is null');
      }

      return user;
    } on FirebaseAuthException catch (e, stack) {
      logger.e('Sign In Failed: ${e.code}', error: e, stackTrace: stack);
      rethrow;
    } catch (e, stack) {
      logger.e('Sign In: Unexpected error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────────────────────
  // Sign Up (Basic)
  // ────────────────────────────────────────────────────────────────
  Future<User?> signUp(String email, String password) async {
    logger.i('Sign Up: Creating account for $email');

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        logger.i('Sign Up Success: ${user.email} (UID: ${user.uid})');
        await _createUserDocument(user, {
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }

      return user;
    } on FirebaseAuthException catch (e, stack) {
      logger.e('Sign Up Failed: ${e.code}', error: e, stackTrace: stack);
      rethrow;
    } catch (e, stack) {
      logger.e('Sign Up: Unexpected error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────────────────────
  // Sign Up With Details (Full Profile)
  // ────────────────────────────────────────────────────────────────
  Future<User?> signUpWithDetails({
    required String email,
    required String password,
    required String username,
    required String company,
    required String country,
  }) async {
    logger.i('Sign Up With Details: Creating account for $email');

    try {
      // 1. Create Auth User
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        logger.w('Sign Up: User created but null returned');
        return null;
      }

      logger.i('Auth Success: ${user.email} (UID: ${user.uid})');

      // 2. Create Full Firestore Document
      final userData = {
        'email': email,
        'username': username,
        'company': company,
        'country': country,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      };

      await _createUserDocument(user, userData);
      logger.i('Firestore User Doc Created: ${user.uid}');

      return user;
    } on FirebaseAuthException catch (e, stack) {
      logger.e('Sign Up With Details Failed: ${e.code}', error: e, stackTrace: stack);
      rethrow;
    } catch (e, stack) {
      logger.e('Sign Up With Details: Unexpected error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────────────────────
  // Sign Out
  // ────────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    logger.i('Sign Out: Signing out current user');

    try {
      await _firebaseAuth.signOut();
      logger.i('Sign Out Success');
    } catch (e, stack) {
      logger.e('Sign Out Failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────────────────────
  // Helper: Create User Document (Firestore)
  // ────────────────────────────────────────────────────────────────
  Future<void> _createUserDocument(User user, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(
            data,
            SetOptions(merge: true),
          );
    } catch (e, stack) {
      logger.e(
        'Failed to create user document for UID: ${user.uid}',
        error: e,
        stackTrace: stack,
      );
      // Do NOT rethrow — auth already succeeded
    }
  }
}