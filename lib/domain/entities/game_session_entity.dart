import 'player_entity.dart';

class GameSessionEntity {
  final String id;
  final PlayerEntity player1;
  final PlayerEntity player2;
  final bool isActive;
  final String currentTurn;

  const GameSessionEntity({
    required this.id,
    required this.player1,
    required this.player2,
    this.isActive = true,
    required this.currentTurn,
  });

  GameSessionEntity copyWith({
    PlayerEntity? player1,
    PlayerEntity? player2,
    bool? isActive,
    String? currentTurn,
  }) {
    return GameSessionEntity(
      id: id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      isActive: isActive ?? this.isActive,
      currentTurn: currentTurn ?? this.currentTurn,
    );
  }
}
