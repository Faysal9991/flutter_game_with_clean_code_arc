// data/repositories/admin_repository.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_faysal_game/services/cludinary_service.dart';
import 'package:injectable/injectable.dart';
import '../../presentation/admin_panel/model/cllanges_model.dart';

@lazySingleton
class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _challengesRef => _firestore.collection('challenges');

  /// Upload badge to ImgBB
  Future<String> _uploadBadgeImage(File image) async {
    final url = await ImgBBService.uploadImage(image);
    if (url == null) throw Exception("ImgBB upload failed");
    return url;
  }

  /// Save challenge: Document ID = week number
  Future<void> saveChallenge(Challenge challenge, File badgeImage) async {
    final weekId = challenge.week.toString();

    final badgeUrl = await _uploadBadgeImage(badgeImage);

    final challengeWithUrl = Challenge(
      id: weekId,
      week: challenge.week,
      title: challenge.title,
      description: challenge.description,
      points: challenge.points,
      badgeUrl: badgeUrl,
      level: challenge.level,
      tasks: challenge.tasks,
    );

    await _challengesRef.doc(weekId).set(challengeWithUrl.toMap());
  }

  /// Stream challenges ordered by week
  Stream<List<Challenge>> getChallenges() {
    return _challengesRef
        .orderBy('week')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) return null;
              return Challenge.fromMap(doc.id, data);
            })
            .whereType<Challenge>()
            .toList());
  }

  /// Get single challenge by week
  Future<Challenge?> getChallengeByWeek(int week) async {
    final doc = await _challengesRef.doc(week.toString()).get();
    if (!doc.exists) return null;
    
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;
    
    return Challenge.fromMap(doc.id, data);
  }
}