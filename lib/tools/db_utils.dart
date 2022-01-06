import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = path.join(await getDatabasesPath(), 'data.db');
    print(dbPath);
    return openDatabase(dbPath, onCreate: (db, version) async {
      print("Creating Database");
      db.execute(
          "CREATE TABLE creds(_id INTEGER PRIMARY KEY, email TEXT, password TEXT)");
      db.execute("CREATE TABLE Cookie(_id INTEGER PRIMARY KEY, cookie TEXT, epoch INTEGER)");
    }, version: 1);
  }

  static Future<void> insertCredentials(Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    await db.insert('creds', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertCookies(Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    await db.insert('Cookie', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DBHelper.database();
    return db.query("creds");
  }

  static Future<List<Map<String, dynamic>>> getCookie() async {
    final db = await DBHelper.database();
    return await db.query("Cookie");
  }

  static Future<void> deleteData() async {
    final db = await DBHelper.database();
    await db.rawDelete("DELETE FROM creds WHERE _id = 1");
  }

  static Future<void> deleteCookie() async {
    final db = await DBHelper.database();
    await db.rawDelete("DELETE FROM Cookie WHERE _id = 1");
  }
}
