import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../services/db_service.dart';
import '../models/user.dart';

final authProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<User?> {
  final Ref ref;
  final DBService _db = DBService.instance;

  AuthController(this.ref) : super(null);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> signUp(String username, String password) async {
    final existing = await _db.getUserByUsername(username);
    if (existing != null) return 'Username already taken';

    final user =
        User(username: username, passwordHash: _hashPassword(password));
    try {
      await _db.createUser(user);
      return null;
    } catch (e) {
      return 'Failed to create user';
    }
  }

  Future<String?> login(String username, String password) async {
    final user = await _db.getUserByUsername(username);
    if (user == null) return 'User not found';

    final hashed = _hashPassword(password);
    if (hashed == user.passwordHash) {
      state = user;
      return null;
    }
    return 'Invalid credentials';
  }

  void logout() {
    state = null;
  }
}
