class PlayerEntity {
  final String id;
  final String name;
  final int score;

  const PlayerEntity({
    required this.id,
    required this.name,
    this.score = 0,
  });

  PlayerEntity copyWith({String? name, int? score}) {
    return PlayerEntity(
      id: id,
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }
}
