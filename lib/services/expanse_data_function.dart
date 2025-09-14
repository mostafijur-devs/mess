import 'package:mass/models/expanse.dart';
import 'package:mass/models/member.dart';
import 'package:mass/repository/expanse_repository.dart';
import 'package:mass/services/db_create.dart';
import 'package:sqflite/sqflite.dart';

class ExpanseDataFunction extends ExpanseRepository {
  DbCreate dbCreate = DbCreate.instance;

  static const String expanseTableQuarry =
      '''Create table $expanseTableName($expanseColumnId integer primary key autoincrement,
  $expanseColumnMemberId integer,
  $expanseColumnAmount integer,
  $expanseColumnCategory text,
  $expanseColumnDescription text,
  $expanseColumnDateTime text
  )''';

  @override
  Future<void> addExpanse(Expanse expanse) async {
    Database? db = await dbCreate.database;
    await db!.insert(expanseTableName, expanse.toJson());

    List<Map<String, dynamic>> memberData = await db.query(
      memberTableName,
      where: 'id = ?',
      whereArgs: [expanse.memberId],
    );
    // await db.query(table)
    if (memberData.isNotEmpty) {
      final currentAmount = memberData.first[columnPersonalAmount] ?? 0;
      final newAmount = currentAmount + (expanse.amount ?? 0);
      await db.update(
        memberTableName,
        {columnPersonalAmount: newAmount},
        where: 'id = ?',
        whereArgs: [expanse.memberId],
      );
    }
  }

  @override
  Future<void> deleteExpanse(int id) async {
    Database? db = await dbCreate.database;
    await db!.delete(
      expanseTableName,
      where: '$expanseColumnId = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Expanse>> getExpanses() async {
    Database? db = await dbCreate.database;
    List<Map<String, dynamic>> expanseMapList = await db!.query(
      expanseTableName,
    );
    return List.generate(
      expanseMapList.length,
      (index) => Expanse.fromJson(expanseMapList[index]),
    ).toList();
  }

  @override
  Future<void> updateExpanse(Expanse expanse) async {
    Database? db = await dbCreate.database;
    await db!.update(
      expanseTableName,
      expanse.toJson(),
      where: '$expanseColumnId = ?',
      whereArgs: [expanse.id],
    );

    List<Map<String, dynamic>> memberData = await db.query(
      memberTableName,
      where: 'id = ?',
      whereArgs: [expanse.memberId],
    );
    // await db.query(table)
    if (memberData.isNotEmpty) {
      final currentAmount = memberData.first[columnPersonalAmount] ?? 0;
      final newAmount = currentAmount + (expanse.amount ?? 0);

      await db.update(
        memberTableName,
        {columnPersonalAmount: newAmount},
        where: 'id = ?',
        whereArgs: [expanse.memberId],
      );
    }
  }

  @override
  Future<List<Expanse>> getExpansesByDate(String date) async {
    Database? db = await dbCreate.database;
    List<Map<String, dynamic>> expanseMapList = await db!.query(
      expanseTableName,
      where: '$expanseColumnDateTime LIKE ?',
      whereArgs: ['$date%'],
    );
    return List.generate(
      expanseMapList.length,
      (index) => Expanse.fromJson(expanseMapList[index]),
    ).toList();
  }

  @override
  Future<List<Expanse>> getExpansesByMonth(int year, int month) async {
    Database? db = await dbCreate.database;
    String startDate = "$year-${month.toString().padLeft(2, '0')}-01";
    String endDate = "$year-${month.toString().padLeft(2, '0')}-31";
    List<Map<String, dynamic>> expanseMapList = await db!.query(
      expanseTableName,
      where: '$expanseColumnDateTime BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );
    return List.generate(
      expanseMapList.length,
      (index) => Expanse.fromJson(expanseMapList[index]),
    ).toList();
  }
}
