import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/game_session_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/repositories/game_repository.dart';

class FirebaseGameRepository implements GameRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<GameSessionEntity> createMatch(PlayerEntity player) async {
    final doc = await _firestore.collection('matches').add({
      'player1': player.name,
      'player2': null,
      'isActive': true,
      'currentTurn': player.id,
    });

    return GameSessionEntity(
      id: doc.id,
      player1: player,
      player2: const PlayerEntity(id: '', name: ''),
      currentTurn: player.id,
    );
  }

  @override
  Future<GameSessionEntity?> joinMatch(String matchId, PlayerEntity player) async {
    final docRef = _firestore.collection('matches').doc(matchId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) return null;

    await docRef.update({
      'player2': player.name,
    });

    final data = snapshot.data()!;
    return GameSessionEntity(
      id: matchId,
      player1: PlayerEntity(id: 'p1', name: data['player1']),
      player2: player,
      currentTurn: data['currentTurn'],
    );
  }

  @override
  Stream<GameSessionEntity> watchMatch(String matchId) {
    return _firestore.collection('matches').doc(matchId).snapshots().map((doc) {
      final data = doc.data()!;
      return GameSessionEntity(
        id: doc.id,
        player1: PlayerEntity(id: 'p1', name: data['player1']),
        player2: PlayerEntity(id: 'p2', name: data['player2'] ?? ''),
        currentTurn: data['currentTurn'],
      );
    });
  }

  @override
  Future<void> submitMove(String matchId, String playerId, dynamic move) async {
    await _firestore.collection('matches').doc(matchId).update({
      'lastMove': move,
      'currentTurn': playerId,
    });
  }
}
