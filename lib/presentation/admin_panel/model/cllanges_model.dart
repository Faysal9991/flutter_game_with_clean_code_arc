
class Challenge {
  final String id;
  final int week;
  final String title;
  final String description;
  final int points;
  final String badgeUrl;
  final int level;
  final List<ChallengeTask> tasks; // ← Change to ChallengeTask

  Challenge({
    required this.id,
    required this.week,
    required this.title,
    required this.description,
    required this.points,
    required this.badgeUrl,
    required this.level,
    required this.tasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'title': title,
      'description': description,
      'points': points,
      'badgeUrl': badgeUrl,
      'level': level,
      'tasks': tasks.map((t) => t.toMap()).toList(), // ← Now works!
    };
  }

  static Challenge fromMap(String id, Map<String, dynamic> map) {
    return Challenge(
      id: id,
      week: map['week'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      points: map['points'] ?? 0,
      badgeUrl: map['badgeUrl'] ?? '',
      level: map['level'] ?? 1,
      tasks: (map['tasks'] as List<dynamic>?)
              ?.map((t) => ChallengeTask.fromMap(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}


// presentation/admin_panel/model/challenge_task.dart
class ChallengeTask {
  final int day;
  final String task;

  ChallengeTask({
    required this.day,
    required this.task,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'task': task,
    };
  }

  factory ChallengeTask.fromMap(Map<String, dynamic> map) {
    return ChallengeTask(
      day: map['day'] ?? 1,
      task: map['task'] ?? '',
    );
  }
}