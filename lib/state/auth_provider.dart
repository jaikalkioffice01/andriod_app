import 'package:flutter/foundation.dart';

import '../data/models/app_user.dart';
import '../data/repositories/auth_repository.dart';

/// ---------------------------------------------------------------------------
/// AUTH PROVIDER (state layer)
/// Holds the authentication state of the app and exposes simple methods
/// (login / signUp / logout) that screens call. Screens NEVER talk to the
/// repository directly - they go through this provider.
///
/// Flow:  LoginScreen -> AuthProvider.login() -> AuthRepository -> prefs
/// ---------------------------------------------------------------------------
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  // ----- state -----
  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;
  bool _busy = false; // true while login/signup call is in-flight
  String? _error; // last error message to show on the auth screens

  AuthStatus get status => _status;
  AppUser? get user => _user;
  bool get busy => _busy;
  String? get error => _error;
  bool get isLoggedIn => _status == AuthStatus.authenticated && _user != null;

  /// Called once at app start: "do we still have a saved session?"
  Future<void> restoreSession() async {
    await _repository.ensureDemoUser();
    _user = _repository.currentUser();
    _status =
        _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Returns true on success. On failure, [error] holds the message.
  Future<bool> login(String email, String password) async {
    _busy = true;
    _error = null;
    notifyListeners();

    final String? errorMessage = await _repository.login(email, password);
    _busy = false;

    if (errorMessage != null) {
      _error = errorMessage;
      notifyListeners();
      return false;
    }

    _user = _repository.currentUser();
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  /// Returns true on success (user is auto-logged-in after signup).
  Future<bool> signUp(String name, String email, String password) async {
    _busy = true;
    _error = null;
    notifyListeners();

    final String? errorMessage = await _repository.signUp(name, email, password);
    _busy = false;

    if (errorMessage != null) {
      _error = errorMessage;
      notifyListeners();
      return false;
    }

    _user = _repository.currentUser();
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Clear the error (e.g. when the user starts typing again).
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
