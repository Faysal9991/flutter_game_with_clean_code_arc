class FirebaseCollections {
  // Existing collections
  static const String games = 'games';
  static const String players = 'players';
  static const String matchmaking = 'matchmaking';

  // User-related collections
  static const String users = 'users'; // main users collection

  // Nested collections inside each user document
  static const String badges = 'badges';
  static const String completedTasks = 'completedTasks';
  static const String dailyChallenges = 'dailyChallenges';
  static const String certificates = 'certificates';
}
