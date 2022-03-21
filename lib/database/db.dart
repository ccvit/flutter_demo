import 'dart:developer';

import 'package:example_cpl/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../blocs/login_bloc.dart';

class DatabaseProvider {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDb();
    return _database;
  }

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future<Database> initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    // sets Android's EncryptedSharePreferences
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    // sqflite initialization
    return await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 2,
      onOpen: (db) {
      },
        // database tables
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user(userId INTEGER PRIMARY KEY, username TEXT)',
        );
      }
    );

  }

  Future<int> maxUserId() async {
    var db = await database;
    List<Map<String,dynamic>>? results = await db?.rawQuery("SELECT MAX(userId) FROM user;");
    return results?[0]["MAX(userId)"];
  }

  Future<int> retrieveUserId(String username) async {
    try {
      var db = await database;
      List<Map<String, dynamic>>? result = await db?.query("user",where: "username = ?",whereArgs: [username]);
      return result?[0]["userId"];
    } catch (e) {
      return -1;
    }
  }

  Future<RegisterType> createUser({ required String username, required password}) async {
    var db = await database;
    int? lastUserId;
    try {
      lastUserId = await maxUserId();
    } catch (e) {
      lastUserId = 0;
    }
    int newUserId = lastUserId + 1;
    Map<String, dynamic> params = {
      "userId": newUserId,
      "username": username
    };
    int? existingUser = await retrieveUserId(username);
    if (existingUser == -1) {
      db?.insert("user", params);
      storePassword(newUserId.toString(), password);
      return RegisterType.succeeded;
    } else {
      return RegisterType.userExists;
    }
  }

  Future deleteUser({required int userId}) async {
    var db = await database;
    db?.delete("user", where: "userId = ?", whereArgs: [userId]);
  }

  Future<Map<String,dynamic>?> retrieveUserData({required int userId}) async {
    var db = await database;
    List<Map<String, dynamic>>? results = await db?.query("user",where: "userId = ?", whereArgs: [userId]);
    return results?[0];
  }

  void storePassword(String userId, String password) async {
    secureStorage.write(key: userId, value: password);
  }

  void deletePassword(String userId) async {
    secureStorage.delete(key: userId);
  }

  Future<String?> retrievePassword(String userId) async {
    String? result = await secureStorage.read(key: userId);
    return result;
  }

  Future<LoginType> checkLogin({required String username, required String password}) async {
    try {
      int? userId = await retrieveUserId(username);
      if (userId != -1) {
        String? storedPassword = await retrievePassword(userId.toString());
        if (storedPassword == password) {
          return LoginType.succeeded;
        } else {
          return LoginType.passwordFail;
        }
      } else {
        return LoginType.usernameFail;
      }
    } catch (e) {
      return LoginType.usernameFail;
    }
  }
}
