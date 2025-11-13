import '../entities/game_session_entity.dart';
import '../entities/player_entity.dart';
import '../repositories/game_repository.dart';

class CreateMatchUseCase {
  final GameRepository repository;

  CreateMatchUseCase(this.repository);

  Future<GameSessionEntity> call(PlayerEntity player) {
    return repository.createMatch(player);
  }
}
