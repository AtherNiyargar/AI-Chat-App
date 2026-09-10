import 'dart:io' show Directory;

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String sNo = 's_no';
const String dbName = "ai_app.db";
const String tableName = "messagesTable";
const String message = "message";
const String isSent = "isSent";

const String createQuery =
    '''
  CREATE TABLE $tableName (
    $sNo INTEGER NOT NULL UNIQUE,
    $message TEXT,
    $isSent INTEGER,
    PRIMARY KEY ($sNo AUTOINCREMENT)
  );
''';

class DatabaseFunctionality {
  DatabaseFunctionality._();

  static final DatabaseFunctionality _instance = DatabaseFunctionality._();

  factory DatabaseFunctionality() {
    return _instance;
  }

  Database? _db;

  Future openDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createQuery);
      },
    );
  }

  Future getDb() async {
    return _db ??= await openDb();
  }

  Future<List<Map<String, Object?>>> getData() async {
    Database db = await getDb();
    return await db.query(tableName, columns: ["message", "isSent"], orderBy: "$sNo DESC");
  }

  Future insertData({required String message, required int isSent}) async {
    Database db = await getDb();
    await db.insert(tableName, {"message": message, "isSent": isSent});
  }
  Future deleteDbEntries() async {
    Database db = await getDb();
    await db.delete(tableName);
  }
}
