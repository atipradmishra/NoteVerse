import 'package:noteverse/database/table_creation.dart';
import 'package:sqflite/sqflite.dart';


import 'chaptermodel.dart';
import 'connections.dart';


class Chaptercurdmap {
  ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Chapter> add(Chapter x) async {
    try {
      Database db = await _getDatabase();
      int ChapterId = await db.rawInsert(ChapterTableCreate.addchapter(x));
      x.ChapterId= ChapterId;
      return x;
    } catch (x) {
      throw Exception();
    }
  }

  Future<bool> update(Chapter x) async {
    try {
      Database db = await _getDatabase();
      int affectedlines = await db.rawUpdate(ChapterTableCreate.updatechap(x));
      if (affectedlines > 0) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<Chapter>> selectall() async {
    try {
      Database db = await _getDatabase();
      List<Map> data = await db.rawQuery(ChapterTableCreate.selectallchapters());
      List<Chapter> s = Chapter.fromSQLiteList(data);
      return s;
    } catch (error) {
      throw Exception();
    }
  }

  Future<void> deleteItem(int id) async {
    final db = await _getDatabase(); // Get a reference to the database.
    await db.delete(
      'Chapter',
      where: 'ChapterId = ?',
      whereArgs: [id],
    );
  }

}