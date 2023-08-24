import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/gorev.dart';

import 'model/gorev_type.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const databaseNameGorev = "gorevabcdefg.db";

  static const _databaseVersion = 1;
  static const tablegorevAdi = "gorev";
  static const tabletype = "gorev_type";
  static const gorevid = 'id';

  static const typeid = "id";
  static const typename = "name";
  static const dutyTypeid = "dutyTypeid";
  static const gorevname = "name";
  static const gorevdurum = "durum";

  static Future<Database> get getDatabaseInstance async {
    Database? database;

    database ??= await _initDatabase();

    return database;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseNameGorev);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE $tablegorevAdi (
      $gorevid INTEGER PRIMARY KEY AUTOINCREMENT,
      $gorevname TEXT NOT NULL, 
      $gorevdurum INTEGER NOT NULL,
      $dutyTypeid INTEGER NOT NULL,
      CONSTRAINT fk_column
        FOREIGN KEY (dutyTypeid)
        REFERENCES $tabletype($typeid)
        ON DELETE CASCADE
      
    )''');
    await db.execute(''' CREATE TABLE $tabletype (
      $typeid INTEGER PRIMARY KEY AUTOINCREMENT,
      $typename TEXT NOT NULL      
                      )''');
  }

  static Future<int> insertGorev(Gorev gorev) async {
    Database db = await getDatabaseInstance;

    return await db.insert(tablegorevAdi, gorev.toJSon());
  }

  static Future<int> insertType(GorevType type) async {
    Database db = await getDatabaseInstance;
    return await db.insert(tabletype, type.toJson());
  }

  static Future<List<Map<String, dynamic>>> queryAllGorevType() async {
    Database db = await getDatabaseInstance;
    return await db.query(tabletype);
  }

  static Future<List<Map<String, dynamic>>> queryAllGorev() async {
    Database db = await getDatabaseInstance;
    return await db.query(tablegorevAdi);
  }

  static Future<int> update(Gorev gorev) async {
    Database db = await getDatabaseInstance;

    return await db.update(tablegorevAdi, gorev.toJSon(),
        where: '$gorevid = ?', whereArgs: [gorev.id]);
  }

  static Future<int> delete_gorev(int id) async {
    Database db = await getDatabaseInstance;
    return await db
        .delete(tablegorevAdi, where: '$gorevid = ?', whereArgs: [id]);
  }

  static Future<void> delete_gorevtype(int typeid) async {
    final db = await getDatabaseInstance;

    await db.delete('gorev_type', where: 'id = ?', whereArgs: [typeid]);
  }
}
