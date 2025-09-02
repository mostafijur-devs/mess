import 'package:mass/repository/member_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../models/member.dart';
import 'db_create.dart';

class MemberDataFunction extends MemberRepository{

  static const String memberTableQuarry =
  '''Create table $memberTableName($columnId integer primary key autoincrement,
       $columnName text ,
        $columnEmail text , 
        $columnPassword text, $columnPhone text, $columnPersonalAmount integer) ''';

  DbCreate dbCreate =  DbCreate.instance;

  @override
  Future<void> addMember (Member member) async{
    Database? db = await dbCreate.database;
    db!.insert(memberTableName, member.toJson());

  }

  @override
  Future<void> deleteMember(int id) async {
   Database? db = await dbCreate.database;
   db!.delete(memberTableName, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<List<Member>> getMember() async{
    Database? db = await dbCreate.database;
    List<Map<String, dynamic>> maps = await db!.query(memberTableName);
    return List.generate(maps.length, (index) => Member.fromJson(maps[index]),);

  }

  @override
  Future<void> updateMember(Member member) async{
    Database? db =await dbCreate.database;
    db!.update(memberTableName, member.toJson(),where: '$columnId = ?', whereArgs: [member.id]);
  }
 //  // Database? db = await instance.database;
 //
 // Future< List<Map<String, dynamic>>> getMember() async {
 //    Database? db = await dbCreate.database;
 //     return await db!.query(tableName);
 //  }
 //  addMember(Member member) async {
 //    Database? db = await dbCreate.database;
 //    db!.insert(tableName, member.toJson());
 //  }
 //  deleteMember(int id) async {
 //    Database? db = await dbCreate.database;
 //    db!.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
 //  }
 //
 //  updateMember(Member member) async {
 //    Database? db = await dbCreate.database;
 //    db!.update(tableName, member.toJson(),
 //        where: '$columnId = ?', whereArgs: [member.id]);
 //  }



}