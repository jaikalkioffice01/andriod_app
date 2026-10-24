import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/app_user.dart';

/// ---------------------------------------------------------------------------
/// AUTH REPOSITORY (data layer)
/// Handles everything about users & sessions, stored in SharedPreferences:
///
///   key 'sk_users'   -> JSON map:
///       { "demo@shopkart.com": {"name": "Demo User", "password": "demo123"} }
///   key 'sk_session' -> email of the currently logged-in user (or absent)
///
/// NOTE: For learning we store passwords in plain text locally.
/// A REAL app must hash passwords and talk to a secure backend. Never
/// do this in production!
/// ---------------------------------------------------------------------------
class AuthRepository {
  AuthRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Make sure the demo account exists so login always works out of the box.
  Future<void> ensureDemoUser() async {
    final Map<String, dynamic> users = _readUsers();
    if (!users.containsKey(AppConstants.demoEmail)) {
      users[AppConstants.demoEmail] = <String, dynamic>{
        'name': AppConstants.demoUserName,
        'password': AppConstants.demoPassword,
      };
      await _prefs.setString(AppConstants.prefsUsers, jsonEncode(users));
    }
  }

  /// Returns the logged-in user, or null if nobody is logged in.
  AppUser? currentUser() {
    final String? email = _prefs.getString(AppConstants.prefsSession);
    if (email == null) return null;

    final Map<String, dynamic> users = _readUsers();
    final dynamic record = users[email];
    if (record == null) return null; // session exists but user was wiped

    return AppUser(
      name: record['name'] as String? ?? email,
      email: email,
    );
  }

  /// LOGIN. Returns null on success, or an error message on failure.
  Future<String?> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600)); // fake API
    await ensureDemoUser();

    final String key = email.trim().toLowerCase();
    final Map<String, dynamic> users = _readUsers();
    final dynamic record = users[key];

    if (record == null) {
      return 'No account found for this email. Try signing up!';
    }
    if (record['password'] != password) {
      return 'Wrong password. Please try again.';
    }

    await _prefs.setString(AppConstants.prefsSession, key);
    return null; // success
  }

  /// SIGN UP. Returns null on success, or an error message on failure.
  Future<String?> signUp(String name, String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600)); // fake API
    await ensureDemoUser();

    final String key = email.trim().toLowerCase();
    final Map<String, dynamic> users = _readUsers();

    if (users.containsKey(key)) {
      return 'An account with this email already exists. Please log in.';
    }

    users[key] = <String, dynamic>{
      'name': name.trim(),
      'password': password,
    };
    await _prefs.setString(AppConstants.prefsUsers, jsonEncode(users));
    await _prefs.setString(AppConstants.prefsSession, key); // auto-login
    return null; // success
  }

  /// LOGOUT: forget the session (the registered user record stays saved).
  Future<void> logout() async {
    await _prefs.remove(AppConstants.prefsSession);
  }

  // ----- private helpers -----

  Map<String, dynamic> _readUsers() {
    final String? raw = _prefs.getString(AppConstants.prefsUsers);
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    final dynamic decoded = jsonDecode(raw);
    return (decoded as Map).cast<String, dynamic>();
  }
}
