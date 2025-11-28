// lib/services/local_storage_service.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocalStorageService {
  static const String _keyUid = 'user_uid';
  static const String _keyEmail = 'user_email';
  static const String _keyUsername = 'user_username';

  late SharedPreferences _prefs;

  @preResolve
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user
  Future<void> saveUser(String uid, String email, String username) async {
    await _prefs.setString(_keyUid, uid);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyUsername, username);
  }

  // Get user
  Map<String, String?> get user {
    return {
      'uid': _prefs.getString(_keyUid),
      'email': _prefs.getString(_keyEmail),
      'username': _prefs.getString(_keyUsername),
    };
  }

  // Check if logged in
  bool get isLoggedIn => _prefs.getString(_keyUid) != null;

  // Check if admin
  bool get isAdmin => _prefs.getString(_keyEmail) == 'admin@gmail.com';

  // Logout
  Future<void> clearUser() async {
    await _prefs.remove(_keyUid);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyUsername);
  }
}