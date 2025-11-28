class Challenge {
  final String id;               // Firestore doc id (e.g. "1")
  final int week;                // 1-35
  final String title;
  final String description;
  final int points;
  final String badgeUrl;
  final int level;
  final List<DailyTask> tasks;
  final DateTime? weekStart;     // optional – can be calculated on the fly

  Challenge({
    required this.id,
    required this.week,
    required this.title,
    required this.description,
    required this.points,
    required this.badgeUrl,
    required this.level,
    required this.tasks,
    this.weekStart,
  });

  // ---------- toMap (admin save) ----------
  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'title': title,
      'description': description,
      'points': points,
      'badgeUrl': badgeUrl,
      'level': level,
      'tasks': tasks.map((t) => t.toMap()).toList(),
      // optional: store weekStart if you want it persisted
    };
  }

  // ---------- fromMap (user fetch) ----------
  factory Challenge.fromMap(String id, Map<String, dynamic> map) {
    final tasksRaw = map['tasks'] as List<dynamic>? ?? [];
    final List<DailyTask> tasks = tasksRaw.map((e) {
      final m = e as Map<String, dynamic>;
      return DailyTask(
        day: (m['day'] as num?)?.toInt() ?? 1,
        task: m['task'] as String? ?? '',
        completed: m['completed'] as bool? ?? false,
      );
    }).toList();

    // Fill missing days (1-7)
    final Set<int> existing = tasks.map((t) => t.day).toSet();
    for (int d = 1; d <= 7; d++) {
      if (!existing.contains(d)) {
        tasks.add(DailyTask(day: d, task: '', completed: false));
      }
    }
    tasks.sort((a, b) => a.day.compareTo(b.day));

    return Challenge(
      id: id,
      week: (map['week'] as num?)?.toInt() ?? int.tryParse(id) ?? 1,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      points: (map['points'] as num?)?.toInt() ?? 0,
      badgeUrl: map['badgeUrl'] as String? ?? '',
      level: (map['level'] as num?)?.toInt() ?? 1,
      tasks: tasks,
    );
  }
}

class DailyTask {
  final int day;          // 1-7
  final String task;
  bool completed;

  DailyTask({required this.day, required this.task, this.completed = false});

  Map<String, dynamic> toMap() => {
        'day': day,
        'task': task,
        'completed': completed,
      };
}