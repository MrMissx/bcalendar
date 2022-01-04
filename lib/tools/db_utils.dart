import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = path.join(await getDatabasesPath(), 'data.db');
    print(dbPath);
    return openDatabase(dbPath, onCreate: (db, version) async {
      db.execute(
          "CREATE TABLE creds(_id INTEGER PRIMARY KEY, email TEXT, password TEXT)");
    }, version: 1);
  }

  static Future<void> insertCredentials(Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    if (await getData() == []) {
      await db.insert('creds', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db
          .update('creds', data, where: '_id = ?', whereArgs: [data["_id"]]);
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DBHelper.database();
    return db.query("creds");
  }

  static Future<void> deleteData() async {
    final db = await DBHelper.database();
    print("Deleting db");
    await db.delete("creds", where: "_id = ?", whereArgs: ["1"]);
  }
}
