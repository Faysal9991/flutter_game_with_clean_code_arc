// lib/data/repositories/home_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_faysal_game/core/utils/logger.dart';
import 'package:flutter_faysal_game/services/localdata_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalStorageService _storage;

  HomeRepository(this._storage);

  // ────────────────────────────────────────────────
  // Logged-in Firebase User
  // ────────────────────────────────────────────────
  User? get currentUser => _firebaseAuth.currentUser;

  // ────────────────────────────────────────────────
  // OFFLINE USER (SharedPreferences)
  // ────────────────────────────────────────────────
  Map<String, String?> get offlineUser => _storage.user;

  // ────────────────────────────────────────────────
  // Get USER PROFILE from Firestore
  // /users/{uid}/profile
  // ────────────────────────────────────────────────
 // ────────────────────────────────────────────────
// Get USER PROFILE + STATS in ONE call
// ────────────────────────────────────────────────
Future<Map<String, dynamic>?> getUserProfileAndStats() async {
  final uid = currentUser?.uid;
  if (uid == null) return null;

  logger.d("Fetching profile + stats for user: $uid");

  final snapshot = await _firestore.collection('users').doc(uid).get();
  if (!snapshot.exists) return null;

  final data = snapshot.data()!;
  return {
    'profile': data['profile'] as Map<String, dynamic>?,
    'stats':   data['stats']   as Map<String, dynamic>?,
  };
}

  // ────────────────────────────────────────────────
  // LIVE USER PROFILE UPDATES (Stream)
  // ────────────────────────────────────────────────
  Stream<Map<String, dynamic>?> userProfileStream() {
    final uid = currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore.collection('users').doc(uid).snapshots().map((snap) {
      return snap.data()?['profile'] as Map<String, dynamic>?;
    });
  }

  // ────────────────────────────────────────────────
  // Get USER STATS
  // /users/{uid}/stats
  // ────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getUserStats() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;

    logger.d("Fetching stats for user: $uid");

    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return null;

    return snapshot.data()?['stats'] as Map<String, dynamic>?;
  }

  // ────────────────────────────────────────────────
  // LIVE STATS STREAM
  // ────────────────────────────────────────────────
  Stream<Map<String, dynamic>?> userStatsStream() {
    final uid = currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore.collection('users').doc(uid).snapshots().map((snap) {
      return snap.data()?['stats'] as Map<String, dynamic>?;
    });
  }

  // ────────────────────────────────────────────────
  // SIGN OUT
  // ────────────────────────────────────────────────
  Future<void> signOut() async {
    logger.i("Home: Sign out");
    await _firebaseAuth.signOut();
    await _storage.clearUser();
  }
}
