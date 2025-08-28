import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  DBService._internal();
  static DBService get instance => _instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('app.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE users(
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT UNIQUE,
password TEXT
)
''');
      },
    );
  }

  Future<int> createUser(User user) async {
    final db = await database;
    return await db.rawInsert(
      'INSERT INTO users (username, password) VALUES (?, ?)',
      [user.username, user.passwordHash],
    );
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.rawQuery(
      'SELECT * FROM users WHERE username = ?',
      [username],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
