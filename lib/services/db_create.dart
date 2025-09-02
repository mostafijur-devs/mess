import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expanse.dart';
import '../models/member.dart';
import 'member_data_function.dart';

class DbCreate {
  DbCreate._();

  Database? _db;
  static final DbCreate instance = DbCreate._();

  // Future<Database?> get database async {
  //    if (_db == null) {
  //      _db = await initDb();
  //    }
  //    return _db;
  //  }
  Future<Database?> get database async {
    _db ??= await initDb();
    return _db;
  }

  Future<Database?> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mass.db');
    Database myDb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(MemberDataFunction.memberTableQuarry);
        db.execute(expanseTableQuarry);
      },
      onUpgrade: (db, oldVersion, newVersion) {},
    );
    return myDb;
  }



  static const String expanseTableQuarry =
      '''Create table $expanseTableName($expanseColumnId integer primary key autoincrement,
  $expanseColumnMemberId integer,
  $expanseColumnAmount integer,
  $expanseColumnCategory text,
  $expanseColumnDescription text
  )''';
  //
  // getMember() async {
  //   Database? db = await instance.database;
  //   List<Map<String, dynamic>> maps = await db!.query(tableName);
  // }
}
