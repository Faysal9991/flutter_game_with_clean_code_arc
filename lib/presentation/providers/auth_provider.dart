import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/di/injection_container.dart';

@lazySingleton
class AuthProvider with ChangeNotifier {
  final _authRepository = getIt<AuthRepository>();

  User? _user;
  User? get user => _user;

  AuthProvider() {
    _authRepository.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authRepository.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _authRepository.signUp(email, password);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
