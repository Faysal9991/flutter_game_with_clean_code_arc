import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final UserProfile profile;
  final UserStats stats;

  AppUser({
    required this.profile,
    required this.stats,
  });

  /// Convert Firestore data to AppUser model
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      profile: UserProfile.fromMap(data['profile'] ?? {}),
      stats: UserStats.fromMap(data['stats'] ?? {}),
    );
  }

  /// Convert model to JSON (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'profile': profile.toMap(),
      'stats': stats.toMap(),
    };
  }
}

class UserProfile {
  final String username;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? location;
  final Timestamp? createdAt;
  final Timestamp? lastLogin;

  UserProfile({
    required this.username,
    required this.email,
    this.displayName,
    this.photoURL,
    this.location,
    this.createdAt,
    this.lastLogin,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      location: map['location'],
      createdAt: map['createdAt'],
      lastLogin: map['lastLogin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'displayName': displayName ?? username,
      'photoURL': photoURL,
      'location': location,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'lastLogin': lastLogin ?? FieldValue.serverTimestamp(),
    };
  }
}

class UserStats {
  final int greenCoins;
  final int completedDays;
  final int xp;
  final int level;
  final int streak;
  final Timestamp? currentStreakStartDate;
  final int longestStreak;
  final int totalTasksCompleted;

  UserStats({
    this.greenCoins = 0,
    this.xp = 0,
    this.level = 0,
    this.streak = 0,
    this.completedDays=0,
    this.currentStreakStartDate,
    this.longestStreak = 0,
    this.totalTasksCompleted = 0,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      greenCoins: map['greenCoins'] ?? 0,
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 0,
      streak: map['streak'] ?? 0,
      completedDays: map['completedDays']??0,
      currentStreakStartDate: map['currentStreakStartDate'],
      longestStreak: map['longestStreak'] ?? 0,
      totalTasksCompleted: map['totalTasksCompleted'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'greenCoins': greenCoins,
      'xp': xp,
      'level': level,
      'streak': streak,
      'completedDays':completedDays,
      'currentStreakStartDate': currentStreakStartDate ?? FieldValue.serverTimestamp(),
      'longestStreak': longestStreak,
      'totalTasksCompleted': totalTasksCompleted,
    };
  }
}
