import '../entities/game_session_entity.dart';
import '../entities/player_entity.dart';

abstract class GameRepository {
  Future<GameSessionEntity> createMatch(PlayerEntity player);
  Future<GameSessionEntity?> joinMatch(String matchId, PlayerEntity player);
  Stream<GameSessionEntity> watchMatch(String matchId);
  Future<void> submitMove(String matchId, String playerId, dynamic move);
}
