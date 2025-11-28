// presentation/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/auth_repository.dart';

@lazySingleton
class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthProvider(this._authRepository) {
    _authRepository.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authRepository.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e));
      rethrow;
    } catch (e) {
      _setError('An unexpected error occurred');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

Future<void> signUpWithDetails({
  required String email,
  required String password,
  required String username,
  required String location,
}) async {
  try {
    _setLoading(true);
    _setError(null);
    await _authRepository.signUpWithDetails(
      email: email,
      password: password,
      username: username, location: location,
    );
  } on FirebaseAuthException catch (e) {
    _setError(_getErrorMessage(e));
    rethrow;
  } catch (e) {
    _setError('An unexpected error occurred');
    rethrow;
  } finally {
    _setLoading(false);
  }
}
 
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authRepository.signOut();
    } catch (e) {
      _setError('Failed to sign out');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password';
      default:
        return e.message ?? 'An error occurred. Please try again';
    }
  }
}